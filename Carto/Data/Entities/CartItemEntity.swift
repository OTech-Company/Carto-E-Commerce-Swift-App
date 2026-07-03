//
//  CartItemEntity.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

struct CartItemEntity: Identifiable, Equatable {
    let id: Int
    let product: Product
    let selectedVariant: ProductVariant
    var quantity: Int
    let addedAt: Date
    
    // UI Computing Helper
    var totalLineCost: Double {
        let variantPrice = Double(selectedVariant.price) ?? 0.0
        return variantPrice * Double(quantity)
    }
}
