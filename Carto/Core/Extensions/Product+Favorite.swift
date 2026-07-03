//
//  Product+Favorite.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

extension Product {
    init(favorite: FavoriteItem) {
        self.init(
            id: favorite.id,
            title: favorite.title,
            description: "",
            vendor: "",
            productType: "",
            handle: "",
            status: "active",
            tags: [],
            variants: [
                ProductVariant(
                    id: favorite.id,
                    productId: favorite.id,
                    title: "Default",
                    price: String(favorite.price),
                    sku: "",
                    compareAtPrice: favorite.compareAtPrice.map { String($0) },
                    inventoryQuantity: 0
                )
            ],
            images: [
                ProductImage(id: favorite.id, productId: favorite.id, alt: favorite.title, src: favorite.imageURL)
            ],
            options: []
        )
    }
}
