//
//  ProductDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Variables

struct StorefrontProductsVariables: Encodable {
    let first: Int
    let after: String?
}

struct StorefrontProductByHandleVariables: Encodable {
    let handle: String
}

struct StorefrontSearchProductsVariables: Encodable {
    let query: String
    let first: Int
}

// MARK: - Responses

struct StorefrontProductsResponse: Decodable {
    let products: StorefrontConnection<StorefrontProduct>
}

struct StorefrontProductResponse: Decodable {
    let productByHandle: StorefrontProduct?
}

// MARK: - Models

struct StorefrontProduct: Decodable {
    let id: String
    let title: String
    let handle: String
    let description: String?
    let vendor: String?
    let productType: String?
    let status: String?
    let tags: [String]
    let images: StorefrontConnection<StorefrontImage>
    let variants: StorefrontConnection<StorefrontProductVariant>
    let options: [StorefrontOption]?
}

struct StorefrontProductVariant: Decodable {
    let id: String
    let title: String
    let sku: String?
    let availableForSale: Bool
    let price: StorefrontMoney
    let compareAtPrice: StorefrontMoney?
}

struct StorefrontOption: Decodable {
    let id: String?
    let name: String
    let values: [String]
}
