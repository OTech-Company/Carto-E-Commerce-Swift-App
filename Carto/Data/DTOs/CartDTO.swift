//
//  OrderAndCartDTOs.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

// MARK: - Core Cart Structures (REST Admin API Compliant)

struct CartDTO: Decodable {
    let id: String // Note: Shopify persistent client-side cart tokens can be alpha-numeric hashes
    let token: String?
    let note: String?
    let attributes: [String: String]?
    let originalTotalPrice: Int?          // Shopify REST returns cart totals in cents or flat numbers
    let totalPrice: Int?
    let items: [CartLineDTO]?              // Replaces 'lines' to match REST keys natively

}



struct CartLineDTO: Decodable {
    let id: Int // Specific line item tracker number
    let productId: Int?
    let variantId: Int?
    let title: String?
    let quantity: Int
    let price: Int?                        // Price in cents or flat number representation
    let sku: String?
    let vendor: String?
    let handle: String?

}
