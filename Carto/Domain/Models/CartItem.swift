//
//  CartItem.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

struct CartItem: Identifiable, Equatable {
    let productId: Int
    let product: Product
    var selectedColor: String
    var selectedSize: String
    var quantity: Int
    let savedAt: Date

    var id: String { "\(productId)_\(selectedColor)_\(selectedSize)" }

    var selectedVariant: ProductVariant? {
        product.variantFor(color: selectedColor, size: selectedSize)
    }

    var availableStock: Int {
        selectedVariant?.inventoryQuantity ?? 0
    }

    var isOutOfStock: Bool {
        availableStock <= 0
    }

    var isAtStockLimit: Bool {
        quantity >= availableStock
    }
}

extension CartItem {
    init(product: Product, selectedColor: String, selectedSize: String, quantity: Int = 1, savedAt: Date = Date()) {
        self.productId = product.id
        self.product = product
        self.selectedColor = selectedColor
        self.selectedSize = selectedSize
        self.quantity = quantity
        self.savedAt = savedAt
    }

    static func makeId(productId: Int, color: String, size: String) -> String {
        "\(productId)_\(color)_\(size)"
    }
}
