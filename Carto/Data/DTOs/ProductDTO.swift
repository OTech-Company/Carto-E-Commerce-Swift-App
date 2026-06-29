//
//  ProductDTO.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//

import Foundation

struct ProductDTO: Codable {
    let id: String
    let title: String
    let descriptionHtml: String?
    let vendor: String?
    let productType: String?
    let tags: [String]?
    let images: [ImageDTO]?
    let variants: [VariantDTO]?
    let options: [ProductOptionDTO]?
}

struct VariantDTO: Codable {
    let id: String
    let title: String
    let price: String
    let compareAtPrice: String?
    let availableForSale: Bool
    let sku: String?
    let selectedOptions: [SelectedOptionDTO]?
}

struct ImageDTO: Codable {
    let id: String?
    let src: String
    let altText: String?
}

struct ProductOptionDTO: Codable {
    let name: String
    let values: [String]
}

struct SelectedOptionDTO: Codable {
    let name: String
    let value: String
}
