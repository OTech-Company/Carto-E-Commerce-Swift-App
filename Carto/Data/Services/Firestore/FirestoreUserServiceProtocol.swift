//
//  FirestoreUserServiceProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

protocol FirestoreUserServiceProtocol {
    func saveUser(dto: UserFirestoreDTO) async throws
    func fetchUser(uid: String) async throws -> UserFirestoreDTO
    func isEmailRegistered(_ email: String) async throws -> Bool
}
