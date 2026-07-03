//
//  AuthenticationRepositoryImpl.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import FirebaseFirestore
import FirebaseAuth

final class AuthenticationRepositoryImpl: AuthenticationRepositoryProtocol {

    private let firebaseAuthService: FirebaseAuthServiceProtocol
    private let firestoreUserService: FirestoreUserServiceProtocol
    private let guestSessionStore: GuestSessionStoreProtocol

    init(
        firebaseAuthService: FirebaseAuthServiceProtocol = FirebaseAuthService(),
        firestoreUserService: FirestoreUserServiceProtocol = FirestoreUserService(),
        guestSessionStore: GuestSessionStoreProtocol = GuestSessionStore()
    ) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreUserService = firestoreUserService
        self.guestSessionStore = guestSessionStore
    }

    // MARK: - Authentication

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

            do {
                try await firebaseAuthService.deleteCurrentUser()
            } catch {
                print("Rollback failed: \(error)")
            }

            throw AuthError.firestoreWriteFailed
        }

        guestSessionStore.setGuest(false)

        return FirebaseUserMapper.toDomain(
            authResult: authUser,
            firestoreData: dto
        )
    }

    func login(email: String, password: String) async throws -> User {

        let authUser = try await firebaseAuthService.signIn(
            email: email,
            password: password
        )

        let dto = try await firestoreUserService.fetchUser(
            uid: authUser.uid
        )

        guestSessionStore.setGuest(false)

        return FirebaseUserMapper.toDomain(
            authResult: authUser,
            firestoreData: dto
        )
    }

    func signOut() {

        try? firebaseAuthService.signOut()

        guestSessionStore.setGuest(false)
    }

    // MARK: - Session

    func restoreSession() async -> SessionState {

        if guestSessionStore.isGuest {
            return .guest
        }

        guard let firebaseUser = Auth.auth().currentUser else {
            return .unauthenticated
        }

        try? await firebaseUser.reload()

        do {

            let user = try await currentUser(
                firebaseUser: firebaseUser
            )

            return .authenticated(user)

        } catch {

            return .unauthenticated
        }
    }

    func continueAsGuest() {
        
        guestSessionStore.setGuest(true)
    }

    // MARK: - Email Verification

    func checkEmailVerified() async -> Bool {
        guard let firebaseUser = Auth.auth().currentUser else { return false }
        try? await firebaseUser.reload()
        return firebaseUser.isEmailVerified
    }
    
    func sendEmailVerification() async throws {

        try await firebaseAuthService.sendEmailVerification()
    }

    func sendPasswordReset(email: String) async throws {

        let isRegistered = try await firestoreUserService.isEmailRegistered(email)

        guard isRegistered else {
            throw AuthError.userNotFound
        }

        try await firebaseAuthService.sendPasswordReset(email: email)
    }
}

private extension AuthenticationRepositoryImpl {

    func currentUser(
        firebaseUser: FirebaseAuth.User
    ) async throws -> User {

        let dto = try await firestoreUserService.fetchUser(
            uid: firebaseUser.uid
        )

        let authUser = FirebaseAuthUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            isEmailVerified: firebaseUser.isEmailVerified
        )

        return FirebaseUserMapper.toDomain(
            authResult: authUser,
            firestoreData: dto
        )
    }
}
