//
//  FavoriteItem.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

struct FavoriteItem: Identifiable, Equatable {
    let id: Int
    let product: Product
    let savedAt: Date
}

extension FavoriteItem {
    init(product: Product, savedAt: Date = Date()) {
        self.id = product.id
        self.product = product
        self.savedAt = savedAt
    }
}
