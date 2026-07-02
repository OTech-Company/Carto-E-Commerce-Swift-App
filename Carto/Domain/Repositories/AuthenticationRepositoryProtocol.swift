//
//  AuthenticationRepositoryProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 29/06/2026.
//

import Foundation

protocol AuthenticationRepositoryProtocol {
    func register(input: RegisterInput) async throws -> User
    func login(email: String, password: String) async throws -> User
    func restoreSession() async -> SessionState
    func continueAsGuest()
    func signOut()
    func sendEmailVerification() async throws
    func checkEmailVerified() async -> Bool
    func sendPasswordReset(email: String) async throws
}
