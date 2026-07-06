//
//  CartFireStoreRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation
import FirebaseFirestore

protocol CartFirestoreRemoteDataSourceProtocol {
    func fetchAll(uid: String) async throws -> [CartItem]
    func save(_ item: CartItem, uid: String) async throws
    func delete(id: String, uid: String) async throws
}

final class CartFirestoreRemoteDataSource: CartFirestoreRemoteDataSourceProtocol {
    private let firestore: Firestore

    init(firestore: Firestore = Firestore.firestore()) {
        self.firestore = firestore
    }

    private func collection(uid: String) -> CollectionReference {
        firestore.collection("carts").document(uid).collection("items")
    }

    func fetchAll(uid: String) async throws -> [CartItem] {
        let snapshot = try await collection(uid: uid).getDocuments()
        return snapshot.documents.compactMap { doc -> CartItem? in
            let data = doc.data()
            guard
                let productMap = data["product"] as? [String: Any],
                let product = Product(firestoreMap: productMap),
                let color = data["selectedColor"] as? String,
                let size = data["selectedSize"] as? String,
                let quantity = data["quantity"] as? Int,
                let timestamp = data["savedAt"] as? Timestamp
            else { return nil }

            return CartItem(product: product, selectedColor: color, selectedSize: size, quantity: quantity, savedAt: timestamp.dateValue())
        }
    }

    func save(_ item: CartItem, uid: String) async throws {
        let product = item.product

        try await collection(uid: uid).document(item.id).setData([
            "product": product.asFirestoreMap,
            "title": product.title,
            "price": product.price,
            "selectedColor": item.selectedColor,
            "selectedSize": item.selectedSize,
            "quantity": item.quantity,
            "savedAt": Timestamp(date: item.savedAt)
        ])
    }

    func delete(id: String, uid: String) async throws {
        try await collection(uid: uid).document(id).delete()
    }
}
