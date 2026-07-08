//
//  Cart.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct CartModel: Hashable {
    let id: String
    let checkoutURL: String
    let totalQuantity: Int
    let lines: [CartLine]
    let discountCodes: [CartDiscountCode]
    let subtotal: String
    let total: String
    let tax: String?
    let currencyCode: String
}

struct CartDiscountCode: Hashable {
    let code: String
    let isApplicable: Bool
}

struct CartLine: Hashable {
    let id: String
    let variantId: String
    let productTitle: String
    let variantTitle: String
    let quantity: Int
    let price: String
}
