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
    
    enum CodingKeys: String, CodingKey {
        case id, src
        case altText = "altText"
        case alt = "alt"
        case alt_text = "alt_text"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        src = try container.decode(String.self, forKey: .src)

        // Accept multiple possible alt text keys used by REST/GraphQL
        altText = try container.decodeIfPresent(String.self, forKey: .altText)
            ?? container.decodeIfPresent(String.self, forKey: .alt)
            ?? container.decodeIfPresent(String.self, forKey: .alt_text)
    }

    // Keep a memberwise initializer for places that construct ProductDTO in tests
    init(id: String? = nil, src: String, altText: String? = nil) {
        self.id = id
        self.src = src
        self.altText = altText
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(src, forKey: .src)
        // Prefer GraphQL-style key when encoding
        try container.encodeIfPresent(altText, forKey: .altText)
    }
}

struct ProductOptionDTO: Codable {
    let name: String
    let values: [String]
}

struct SelectedOptionDTO: Codable {
    let name: String
    let value: String
}

// Provide flexible decoding for ProductDTO to accept both GraphQL (descriptionHtml)
// and Admin REST (body_html) naming conventions.
extension ProductDTO {
    enum CodingKeys: String, CodingKey {
        case id, title
        case descriptionHtml = "descriptionHtml"
        case body_html = "body_html"
        case vendor, productType, tags, images, variants, options
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        // Accept either GraphQL or REST naming for description
        descriptionHtml = try container.decodeIfPresent(String.self, forKey: .descriptionHtml)
            ?? container.decodeIfPresent(String.self, forKey: .body_html)

        vendor = try container.decodeIfPresent(String.self, forKey: .vendor)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        images = try container.decodeIfPresent([ImageDTO].self, forKey: .images)
        variants = try container.decodeIfPresent([VariantDTO].self, forKey: .variants)
        options = try container.decodeIfPresent([ProductOptionDTO].self, forKey: .options)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(descriptionHtml, forKey: .descriptionHtml)
        try container.encodeIfPresent(vendor, forKey: .vendor)
        try container.encodeIfPresent(productType, forKey: .productType)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(variants, forKey: .variants)
        try container.encodeIfPresent(options, forKey: .options)
    }
}
