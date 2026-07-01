//
//  AuthSession.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
final class AuthSession: ObservableObject {

    private let firestoreUserService: FirestoreUserServiceProtocol
    private let guestSessionStore: GuestSessionStoreProtocol
    private let sessionSubject: CurrentValueSubject<SessionState, Never>
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    var sessionPublisher: AnyPublisher<SessionState, Never> {
        sessionSubject.eraseToAnyPublisher()
    }

    var currentUser: User? {
        sessionSubject.value.user
    }

    init(
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

    private func observeFirebaseAuth() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self else { return }
            Task { @MainActor in
                await self.handleAuthStateChange(firebaseUser: firebaseUser)
            }
        }
    }

    private func handleAuthStateChange(firebaseUser: FirebaseAuth.User?) async {
        if guestSessionStore.isGuest {
            sessionSubject.send(.guest)
            return
        }

        guard let firebaseUser else {
            sessionSubject.send(.unauthenticated)
            return
        }

        do {
            try await firebaseUser.reload()
            let user = try await currentUser(firebaseUser: firebaseUser)
            sessionSubject.send(.authenticated(user))
        } catch {
            sessionSubject.send(.unauthenticated)
        }
    }

    private func currentUser(firebaseUser: FirebaseAuth.User) async throws -> User {
        let dto = try await firestoreUserService.fetchUser(uid: firebaseUser.uid)
        let authUser = FirebaseAuthUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            isEmailVerified: firebaseUser.isEmailVerified
        )
        return FirebaseUserMapper.toDomain(authResult: authUser, firestoreData: dto)
    }
    
    func refreshSession() async {
        await handleAuthStateChange(firebaseUser: Auth.auth().currentUser)
    }
}
