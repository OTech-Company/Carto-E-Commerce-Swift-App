import FirebaseFirestore
import FirebaseAuth


final class AuthenticationRepositoryImpl: AuthenticationRepositoryProtocol {

    private let firebaseAuthService: FirebaseAuthServiceProtocol
    private let firestoreUserService: FirestoreUserServiceProtocol
    private let shopifyAuthService: ShopifyAuthenticationServiceProtocol
    private let guestSessionStore: GuestSessionStoreProtocol

    init(
        firebaseAuthService: FirebaseAuthServiceProtocol = FirebaseAuthService(),
        firestoreUserService: FirestoreUserServiceProtocol = FirestoreUserService(),
        shopifyAuthService: ShopifyAuthenticationServiceProtocol = ShopifyAuthenticationService(),
        guestSessionStore: GuestSessionStoreProtocol = GuestSessionStore()
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreUserService = firestoreUserService
        self.shopifyAuthService = shopifyAuthService
        self.guestSessionStore = guestSessionStore
    }

    func register(input: RegisterInput) async throws -> User {

        let authUser = try await firebaseAuthService.createUser(
            email: input.email,
            password: input.password
        )

        try? await firebaseAuthService.updateDisplayName(
            name: "\(input.firstName) \(input.lastName)"
        )

        let dto = UserFirestoreDTO(
            uid: authUser.uid,
            firstName: input.firstName,
            lastName: input.lastName,
            email: input.email
        )

        do {
            try await firestoreUserService.saveUser(dto: dto)
        } catch {
            await rollbackFirebaseUser()
            throw AuthError.firestoreWriteFailed
        }

        do {
            let shopifyCustomerId = try await shopifyAuthService.createCustomer(
                email: input.email,
                password: input.password,
                firstName: input.firstName,
                lastName: input.lastName
            )

            let accessToken = try await shopifyAuthService.createAccessToken(
                email: input.email,
                password: input.password
            )

            try await firestoreUserService.updateShopifyData(
                uid: authUser.uid,
                shopifyCustomerId: shopifyCustomerId,
                customerAccessToken: accessToken
            )

            await guestSessionStore.setGuest(false)

            let updatedDTO = UserFirestoreDTO(
                uid: dto.uid,
                firstName: dto.firstName,
                lastName: dto.lastName,
                email: dto.email,
                shopifyCustomerId: shopifyCustomerId,
                customerAccessToken: accessToken
            )
            return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: updatedDTO)

        } catch {
            await rollbackFirebaseUser()
            await rollbackFirestoreUser(uid: authUser.uid)
            throw error
        }
    }

    // MARK: - Login

    func login(email: String, password: String) async throws -> User {

        let authUser = try await firebaseAuthService.signIn(email: email, password: password)

        let dto = try await firestoreUserService.fetchUser(uid: authUser.uid)

       
        if let shopifyCustomerId = dto.shopifyCustomerId {
            do {
                try await shopifyAuthService.updateCustomerPassword(
                    shopifyCustomerId: shopifyCustomerId,
                    newPassword: password
                )

                let newToken = try await shopifyAuthService.createAccessToken(
                    email: email,
                    password: password
                )

                try await firestoreUserService.updateShopifyData(
                    uid: authUser.uid,
                    shopifyCustomerId: shopifyCustomerId,
                    customerAccessToken: newToken
                )

                await guestSessionStore.setGuest(false)

                let updatedDTO = UserFirestoreDTO(
                    uid: dto.uid,
                    firstName: dto.firstName,
                    lastName: dto.lastName,
                    email: dto.email,
                    shopifyCustomerId: shopifyCustomerId,
                    customerAccessToken: newToken
                )
                return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: updatedDTO)

            } catch let error as AuthError {
                print("[AuthRepo] Shopify sync failed during login: \(error.localizedDescription )")
            } catch {
                print("[AuthRepo] Shopify sync failed during login: \(error.localizedDescription)")
            }
        }

        await guestSessionStore.setGuest(false)
        return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: dto)
    }

    // MARK: - Google Sign-In

    
    func signInWithGoogle() async throws -> User {

        let authUser = try await firebaseAuthService.signInWithGoogle()

        let email = authUser.email ?? ""

        let existingDTO = try? await firestoreUserService.fetchUser(uid: authUser.uid)

        let dto: UserFirestoreDTO
        if let existingDTO {
            dto = existingDTO
        } else {
            let nameParts = splitDisplayName(Auth.auth().currentUser?.displayName)
            let newDTO = UserFirestoreDTO(
                uid: authUser.uid,
                firstName: nameParts.first,
                lastName: nameParts.last,
                email: email
            )
            try await firestoreUserService.saveUser(dto: newDTO)
            dto = newDTO
        }

        let shopifyPassword = generateShopifyPassword(uid: authUser.uid)

        do {
            let shopifyCustomerId: String
            let accessToken: String

            if let existingShopifyId = dto.shopifyCustomerId {
                try await shopifyAuthService.updateCustomerPassword(
                    shopifyCustomerId: existingShopifyId,
                    newPassword: shopifyPassword
                )
                accessToken = try await shopifyAuthService.createAccessToken(
                    email: email,
                    password: shopifyPassword
                )
                shopifyCustomerId = existingShopifyId
            } else {
                let nameParts = splitDisplayName(Auth.auth().currentUser?.displayName)
                shopifyCustomerId = try await shopifyAuthService.createCustomer(
                    email: email,
                    password: shopifyPassword,
                    firstName: nameParts.first,
                    lastName: nameParts.last
                )
                accessToken = try await shopifyAuthService.createAccessToken(
                    email: email,
                    password: shopifyPassword
                )
            }

            try await firestoreUserService.updateShopifyData(
                uid: authUser.uid,
                shopifyCustomerId: shopifyCustomerId,
                customerAccessToken: accessToken
            )

            await guestSessionStore.setGuest(false)

            let updatedDTO = UserFirestoreDTO(
                uid: dto.uid,
                firstName: dto.firstName,
                lastName: dto.lastName,
                email: dto.email,
                shopifyCustomerId: shopifyCustomerId,
                customerAccessToken: accessToken
            )
            return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: updatedDTO)

        } catch {
            print("[AuthRepo] Shopify setup failed during Google Sign-In: \(error.localizedDescription)")
            await guestSessionStore.setGuest(false)
            return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: dto)
        }
    }

    // MARK: - Sign Out

    func signOut() async {
        try? firebaseAuthService.signOut()
        await guestSessionStore.setGuest(false)
    }

    // MARK: - Session

    func continueAsGuest() async {
        await guestSessionStore.setGuest(true)
    }

    // MARK: - Email Verification

    func checkEmailVerified() async -> Bool {
        guard let firebaseUser = Auth.auth().currentUser else { return false }
        try? await firebaseUser.reload()
        await AuthSession.shared.refreshSession()
        return firebaseUser.isEmailVerified
    }

    func sendEmailVerification() async throws {
        try await firebaseAuthService.sendEmailVerification()
    }

    func sendPasswordReset(email: String) async throws {
        let isRegistered = try await firestoreUserService.isEmailRegistered(email)
        guard isRegistered else { throw AuthError.userNotFound }
        try await firebaseAuthService.sendPasswordReset(email: email)
    }
}

// MARK: - Private Helpers

private extension AuthenticationRepositoryImpl {

    func currentUser(firebaseUser: FirebaseAuth.User) async throws -> User {
        let dto = try await firestoreUserService.fetchUser(uid: firebaseUser.uid)
        let authUser = FirebaseAuthUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            isEmailVerified: firebaseUser.isEmailVerified
        )
        return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: dto)
    }

    func rollbackFirebaseUser() async {
        do {
            try await firebaseAuthService.deleteCurrentUser()
        } catch {
            print("[AuthRepo] Firebase rollback failed: \(error.localizedDescription)")
        }
    }

    func rollbackFirestoreUser(uid: String) async {
        do {
            _ = try await firestoreUserService.deleteUser(uid: uid)
        } catch {
            print("[AuthRepo] Firestore rollback check failed: \(error.localizedDescription)")
        }
    }

    func generateShopifyPassword(uid: String) -> String {
        return "Carto@\(uid.prefix(16))#Shopify"
    }

    func splitDisplayName(_ name: String?) -> (first: String, last: String) {
        guard let name, !name.isEmpty else { return (first: "User", last: "") }
        let parts = name.split(separator: " ", maxSplits: 1)
        let first = parts.first.map(String.init) ?? "User"
        let last = parts.dropFirst().first.map(String.init) ?? ""
        return (first: first, last: last)
    }
}
