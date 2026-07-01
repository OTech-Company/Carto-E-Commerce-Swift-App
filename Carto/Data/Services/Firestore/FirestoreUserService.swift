//
//  FirestoreUserService.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation
import FirebaseFirestore

final class FirestoreUserService: FirestoreUserServiceProtocol {

    private let firestore: Firestore
    private let collectionName = "users"

    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }

    func saveUser(dto: UserFirestoreDTO) async throws {
        do {
            try await firestore.collection(collectionName)
                .document(dto.uid)
                .setData(dto.asDictionary)
        } catch {
            throw AuthError.firestoreWriteFailed
        }
    }

    func fetchUser(uid: String) async throws -> UserFirestoreDTO {
        do {
            let snapshot = try await firestore.collection(collectionName)
                .document(uid)
                .getDocument()

            guard
                let data = snapshot.data(),
                let dto = UserFirestoreDTO(dictionary: data)
            else {
                throw AuthError.firestoreWriteFailed
            }
            return dto
        } catch {
            throw AuthError.firestoreWriteFailed
        }
    }
}
