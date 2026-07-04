//
//  FavoritesRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 04/07/2026.
//

import Foundation
import FirebaseFirestore

protocol FavoritesRemoteDataSourceProtocol {
    func fetchAll(uid: String) async throws -> [FavoriteItem]
    func save(_ item: FavoriteItem, uid: String) async throws
    func delete(productId: Int, uid: String) async throws
}

final class FavoritesRemoteDataSource: FavoritesRemoteDataSourceProtocol {
    private let firestore: Firestore

    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }

    private func collection(uid: String) -> CollectionReference {
        firestore.collection("favorites").document(uid).collection("items")
    }

    func fetchAll(uid: String) async throws -> [FavoriteItem] {
        let snapshot = try await collection(uid: uid).getDocuments()
        return snapshot.documents.compactMap { doc in
            guard
                let base64 = doc.data()["productData"] as? String,
                let data = Data(base64Encoded: base64),
                let product = try? JSONDecoder().decode(Product.self, from: data),
                let timestamp = doc.data()["savedAt"] as? Timestamp
            else { return nil }
            return FavoriteItem(id: product.id, product: product, savedAt: timestamp.dateValue())
        }
    }

    func save(_ item: FavoriteItem, uid: String) async throws {
        guard let data = try? JSONEncoder().encode(item.product) else { return }
        try await collection(uid: uid).document("\(item.id)").setData([
            "productData": data.base64EncodedString(),
            "savedAt": Timestamp(date: item.savedAt)
        ])
    }

    func delete(productId: Int, uid: String) async throws {
        try await collection(uid: uid).document("\(productId)").delete()
    }
}
