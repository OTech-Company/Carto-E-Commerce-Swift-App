//
//  AuthSession.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import Foundation
import Combine
import FirebaseAuth

final class AuthSession: ObservableObject {

    // MARK: - Singleton

    static let shared = AuthSession()

    // MARK: - Dependencies

    private let firestoreUserService: FirestoreUserServiceProtocol
    private let guestSessionStore: GuestSessionStoreProtocol
    var sessionState: SessionState = SessionState.loading
    // MARK: - Properties

    private let sessionSubject: CurrentValueSubject<SessionState, Never>
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    var sessionPublisher: AnyPublisher<SessionState, Never> {
        sessionSubject.eraseToAnyPublisher()
    }

    var currentUser: User? {
        sessionSubject.value.user
    }

    // MARK: - Init

    private init(
        firestoreUserService: FirestoreUserServiceProtocol = FirestoreUserService(),
        guestSessionStore: GuestSessionStoreProtocol = GuestSessionStore()
    ) {
        self.firestoreUserService = firestoreUserService
        self.guestSessionStore = guestSessionStore
        self.sessionSubject = CurrentValueSubject(.loading)

        observeFirebaseAuth()
    }

    deinit {
        if let authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(authStateListenerHandle)
        }
    }

    // MARK: - Firebase Listener

    private func observeFirebaseAuth() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self else { return }

            Task { @MainActor in
                await self.handleAuthStateChange(firebaseUser: firebaseUser)
            }
        }
    }

    // MARK: - Session

    @MainActor
    private func handleAuthStateChange(firebaseUser: FirebaseAuth.User?) async {

        if guestSessionStore.isGuest {
            sessionSubject.send(.guest)
            self.sessionState = .guest
            return
        }

        guard let firebaseUser else {
            sessionSubject.send(.unauthenticated)
            self.sessionState = .unauthenticated
            return
        }

        do {
            try await firebaseUser.reload()

            let user = try await currentUser(firebaseUser: firebaseUser)

            sessionSubject.send(.authenticated(user))
            self.sessionState = .authenticated(user)
        } catch {
            sessionSubject.send(.unauthenticated)
            self.sessionState = .unauthenticated
        }
    }

    @MainActor
    func refreshSession() async {
        await handleAuthStateChange(firebaseUser: Auth.auth().currentUser)
    }

    // MARK: - Helpers

    private func currentUser(firebaseUser: FirebaseAuth.User) async throws -> User {

        let dto = try await firestoreUserService.fetchUser(uid: firebaseUser.uid)

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
