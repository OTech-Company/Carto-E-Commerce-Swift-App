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
        return snapshot.documents.compactMap { doc -> FavoriteItem? in
            let data = doc.data()

            guard
                let id = data["id"] as? Int,
                let title = data["title"] as? String,
                let timestamp = data["savedAt"] as? Timestamp
            else { return nil }

            let description = data["description"] as? String ?? ""
            let imageURL = data["imageURL"] as? String ?? ""
            let price = data["price"] as? Double ?? 0
            let compareAtPrice = data["compareAtPrice"] as? Double
            let colors = data["colors"] as? [String] ?? []
            let sizes = data["sizes"] as? [String] ?? []

            var options: [ProductOption] = []
            if !sizes.isEmpty {
                options.append(ProductOption(id: id, productId: id, name: "Size", values: sizes))
            }
            if !colors.isEmpty {
                options.append(ProductOption(id: id, productId: id, name: "Color", values: colors))
            }

            let product = Product(
                id: id,
                title: title,
                description: description,
                vendor: "",
                productType: "",
                handle: "",
                status: "active",
                tags: [],
                variants: [
                    ProductVariant(
                        id: id,
                        productId: id,
                        title: "Default",
                        price: String(price),
                        sku: "",
                        compareAtPrice: compareAtPrice.map { String($0) },
                        inventoryQuantity: 0
                    )
                ],
                images: [
                    ProductImage(id: id, productId: id, alt: title, src: imageURL)
                ],
                options: options
            )

            return FavoriteItem(id: id, product: product, savedAt: timestamp.dateValue())
        }
    }

    func save(_ item: FavoriteItem, uid: String) async throws {
        let product = item.product
        try await collection(uid: uid).document("\(item.id)").setData([
            "id": product.id,
            "title": product.title,
            "description": product.description,
            "imageURL": product.imageURL,
            "price": product.price,
            "compareAtPrice": product.compareAtPrice as Any,
            "colors": product.colors,
            "sizes": product.sizes,
            "savedAt": Timestamp(date: item.savedAt)
        ])
    }

    func delete(productId: Int, uid: String) async throws {
        try await collection(uid: uid).document("\(productId)").delete()
    }
}
