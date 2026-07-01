//  ProductDTO.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

// MARK: - API Response Wrapper
struct ProductListResponse: Decodable {
    let products: [ProductDTO]?
}

struct ProductDetailResponse: Decodable {
    let product: ProductDTO?
}

struct CategoryPoductsResponse: Decodable {
    let products: [ProductDTO]?
}

// MARK: - Product DTO
struct ProductDTO: Decodable {
    /// Changed to Int to resolve the 64-bit number decoding mismatch
    let id: Int?
    let title: String?
    let bodyHtml: String?
    let vendor: String?
    let productType: String?
    let handle: String?
    let status: String?
    let tags: String?
    let variants: [ProductVariantDTO]?
    let images: [ProductImageDTO]?
    let options: [ProductOptionDTO]?
}

// MARK: - Product Variant DTO
struct ProductVariantDTO: Decodable {
    let id: Int
    let productId: Int
    let title: String
    let price: String?
    let sku: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let fulfillmentService: String?
    let inventoryManagement: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let weight: Double?
    let weightUnit: String?
    let inventoryItemId: Int?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let requiresShipping: Bool?
    let adminGraphqlApiId: String?
}

// MARK: - Product Image DTO
struct ProductImageDTO: Decodable {
    let id: Int
    let productId: Int
    let position: Int?
    let createdAt: String?
    let updatedAt: String?
    let alt: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variantIds: [Int]?
    let adminGraphqlApiId: String?
}

// MARK: - Product Option DTO
struct ProductOptionDTO: Decodable {
    let id: Int
    let productId: Int
    let name: String
    let position: Int?
    let values: [String]?
}
