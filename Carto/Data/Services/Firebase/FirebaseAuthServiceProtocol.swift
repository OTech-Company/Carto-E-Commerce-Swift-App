//
//  FirebaseAuthServiceProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

protocol FirebaseAuthServiceProtocol {
    func createUser(email: String, password: String) async throws -> FirebaseAuthUser
    func signIn(email: String, password: String) async throws -> FirebaseAuthUser
    func deleteCurrentUser() async throws
    func updateDisplayName(name: String) async throws
    func signOut() throws
    func sendEmailVerification() async throws
    func sendPasswordReset(email: String) async throws
}
