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
    let description: String?              // Plain text description from GraphQL
    let descriptionHtml: String?          // HTML version from GraphQL/REST
    let vendor: String?
    let productType: String?
    let tags: [String]?
    let availableForSale: Bool?           // NEW: from GraphQL
    let priceRange: PriceRangeDTO?        // NEW: for product lists
    let compareAtPriceRange: PriceRangeDTO? // NEW: for comparing original prices
    let images: [ImageDTO]?
    let variants: [VariantDTO]?
    let options: [ProductOptionDTO]?
}

struct VariantDTO: Codable {
    let id: String
    let title: String
    let price: MoneyDTO                   // CHANGED: was String, now Money object
    let compareAtPrice: MoneyDTO?         // CHANGED: was String?, now Money object
    let availableForSale: Bool
    let quantityAvailable: Int?           // NEW: stock quantity
    let sku: String?
    let selectedOptions: [SelectedOptionDTO]?
    let image: ImageDTO?                  // NEW: variant-specific image
}

// Flexible decoding for VariantDTO to handle both old format (string prices)
// and new format (Money objects) from GraphQL/REST
extension VariantDTO {
    enum CodingKeys: String, CodingKey {
        case id, title, availableForSale, quantityAvailable, sku, selectedOptions, image
        case price, compareAtPrice
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        availableForSale = try container.decode(Bool.self, forKey: .availableForSale)

        // Price: try MoneyDTO first, fallback to string conversion if needed
        if let money = try container.decodeIfPresent(MoneyDTO.self, forKey: .price) {
            price = money
        } else if let stringPrice = try container.decodeIfPresent(String.self, forKey: .price) {
            // Fallback: convert string price to Money object
            price = MoneyDTO(amount: stringPrice, currencyCode: "USD")
        } else {
            throw DecodingError.missingExpectedTypeError(
                MoneyDTO.self,
                at: container.codingPath + [CodingKeys.price]
            )
        }

        // CompareAtPrice: optional Money object
        if let money = try container.decodeIfPresent(MoneyDTO.self, forKey: .compareAtPrice) {
            compareAtPrice = money
        } else if let stringPrice = try container.decodeIfPresent(String.self, forKey: .compareAtPrice) {
            compareAtPrice = MoneyDTO(amount: stringPrice, currencyCode: "USD")
        } else {
            // FIX: Explicitly assign nil if neither condition is met
            compareAtPrice = nil
        }

        quantityAvailable = try container.decodeIfPresent(Int.self, forKey: .quantityAvailable)
        sku = try container.decodeIfPresent(String.self, forKey: .sku)
        selectedOptions = try container.decodeIfPresent([SelectedOptionDTO].self, forKey: .selectedOptions)
        image = try container.decodeIfPresent(ImageDTO.self, forKey: .image)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(price, forKey: .price)
        try container.encodeIfPresent(compareAtPrice, forKey: .compareAtPrice)
        try container.encode(availableForSale, forKey: .availableForSale)
        try container.encodeIfPresent(quantityAvailable, forKey: .quantityAvailable)
        try container.encodeIfPresent(sku, forKey: .sku)
        try container.encodeIfPresent(selectedOptions, forKey: .selectedOptions)
        try container.encodeIfPresent(image, forKey: .image)
    }
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

// MARK: - Pricing Structures (NEW)
struct PriceRangeDTO: Codable {
    let minVariantPrice: MoneyDTO?
    let maxVariantPrice: MoneyDTO?
}

// Provide flexible decoding for ProductDTO to accept both GraphQL (descriptionHtml)
// and Admin REST (body_html) naming conventions.
extension ProductDTO {
    enum CodingKeys: String, CodingKey {
        case id, title, description, vendor, productType, tags, images, variants, options
        case availableForSale
        case priceRange, compareAtPriceRange
        case descriptionHtml = "descriptionHtml"
        case body_html = "body_html"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        // Accept either GraphQL or REST naming for descriptions
        description = try container.decodeIfPresent(String.self, forKey: .description)
        descriptionHtml = try container.decodeIfPresent(String.self, forKey: .descriptionHtml)
            ?? container.decodeIfPresent(String.self, forKey: .body_html)

        vendor = try container.decodeIfPresent(String.self, forKey: .vendor)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        availableForSale = try container.decodeIfPresent(Bool.self, forKey: .availableForSale)
        priceRange = try container.decodeIfPresent(PriceRangeDTO.self, forKey: .priceRange)
        compareAtPriceRange = try container.decodeIfPresent(PriceRangeDTO.self, forKey: .compareAtPriceRange)
        images = try container.decodeIfPresent([ImageDTO].self, forKey: .images)
        variants = try container.decodeIfPresent([VariantDTO].self, forKey: .variants)
        options = try container.decodeIfPresent([ProductOptionDTO].self, forKey: .options)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(descriptionHtml, forKey: .descriptionHtml)
        try container.encodeIfPresent(vendor, forKey: .vendor)
        try container.encodeIfPresent(productType, forKey: .productType)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(availableForSale, forKey: .availableForSale)
        try container.encodeIfPresent(priceRange, forKey: .priceRange)
        try container.encodeIfPresent(compareAtPriceRange, forKey: .compareAtPriceRange)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(variants, forKey: .variants)
        try container.encodeIfPresent(options, forKey: .options)
    }
}

// Helper extension for missing key errors
private extension DecodingError {
    static func missingExpectedTypeError(_ type: Any.Type, at path: [CodingKey]) -> DecodingError {
        return DecodingError.valueNotFound(
            type,
            DecodingError.Context(
                codingPath: path,
                debugDescription: "Expected \(type) but found nil"
            )
        )
    }
}
