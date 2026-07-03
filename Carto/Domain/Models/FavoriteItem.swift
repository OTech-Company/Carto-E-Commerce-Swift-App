//
//  FavoriteItem.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

struct FavoriteItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let imageURL: String
    let price: Double
    let compareAtPrice: Double?
    let savedAt: Date
}

extension FavoriteItem {
    init(product: Product, savedAt: Date = Date()) {
        self.id = product.id
        self.title = product.title
        self.imageURL = product.imageURL
        self.price = product.price
        self.compareAtPrice = product.compareAtPrice
        self.savedAt = savedAt
    }
}
