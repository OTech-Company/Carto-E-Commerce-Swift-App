//
//  Product.swift
//  Carto
//

import Foundation

struct Product: Identifiable, Equatable, Hashable, Codable{
    let id: Int
    let title: String
    let description: String
    let vendor: String
    let productType: String
    let handle: String
    let status: String
    let tags: [String]
    let variants: [ProductVariant]
    let images: [ProductImage]
    let options: [ProductOption]

    var mainImageUrl: String? {
        images.first?.src
    }

    var imageURL: String {
        mainImageUrl ?? ""
    }

    var price: Double {
        Double(variants.first?.price ?? "") ?? 0
    }

    var compareAtPrice: Double? {
        guard let raw = variants.first?.compareAtPrice else { return nil }
        return Double(raw)
    }

    var displayPrice: String {
        guard let baselinePrice = variants.first?.price else { return "N/A" }
        return "$\(baselinePrice)"
    }

    var discountPercentage: Int? {
        guard let compareAtPrice, compareAtPrice > price else { return nil }
        let discount = (compareAtPrice - price) / compareAtPrice * 100
        return Int(discount.rounded())
    }

    var sizes: [String] {
        options.first(where: { $0.name.lowercased() == "size" })?.values ?? []
    }

    var colors: [String] {
        options.first(where: { $0.name.lowercased() == "color" })?.values ?? []
    }
}

struct ProductVariant: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let productId: Int
    let title: String
    let price: String
    let sku: String
    let compareAtPrice: String?
    let inventoryQuantity: Int
    let option1: String?
    let option2: String?
    let option3: String?
    let adminGraphqlApiId: String?
}

struct ProductImage: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let productId: Int
    let alt: String
    let src: String
}

struct ProductOption: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let productId: Int
    let name: String
    let values: [String]
}

extension Product {
    func variantFor(color: String, size: String) -> ProductVariant? {
        variants.first { variant in
            let matchesColor = [variant.option1, variant.option2, variant.option3]
                .compactMap { $0?.lowercased() }
                .contains(color.lowercased())
            let matchesSize = [variant.option1, variant.option2, variant.option3]
                .compactMap { $0?.lowercased() }
                .contains(size.lowercased())
            
            let hasColorOption = !self.colors.isEmpty
            let hasSizeOption = !self.sizes.isEmpty
            
            let colorOK = !hasColorOption || matchesColor
            let sizeOK = !hasSizeOption || matchesSize
            
            let titleOK = variant.title.lowercased().contains(color.lowercased()) &&
                          variant.title.lowercased().contains(size.lowercased())
            
            return (colorOK && sizeOK) || titleOK
        } ?? variants.first
    }

    static let mock = Product(
        id: 1,
        title: "Nike Air Max",
        description: "Lightweight running shoe with breathable mesh upper.",
        vendor: "Nike",
        productType: "Shoes",
        handle: "nike-air-max",
        status: "active",
        tags: ["running", "shoes"],
        variants: [
            ProductVariant(
                id: 1, productId: 1, title: "Default",
                price: "89.99", sku: "NAM-001",
                compareAtPrice: "129.99", inventoryQuantity: 25,
                option1: nil, option2: nil, option3: nil, adminGraphqlApiId: nil
            )
        ],
        images: [
            ProductImage(id: 1, productId: 1, alt: "Nike Air Max", src: "")
        ],
        options: [
            ProductOption(id: 1, productId: 1, name: "Size", values: ["S", "M", "L", "XL"]),
            ProductOption(id: 2, productId: 1, name: "Color", values: ["black", "white", "red"])
        ]
    )

    static let mockProducts: [Product] = [
        .mock,
        Product(
            id: 2, title: "Adidas Runner", description: "",
            vendor: "Adidas", productType: "Shoes", handle: "adidas-runner",
            status: "active", tags: ["running"],
            variants: [
                ProductVariant(
                    id: 2, productId: 2, title: "Default", price: "74.99", sku: "AR-002",
                    compareAtPrice: "99.99", inventoryQuantity: 10,
                    option1: nil, option2: nil, option3: nil, adminGraphqlApiId: nil
                )
            ],
            images: [ProductImage(id: 2, productId: 2, alt: "Adidas Runner", src: "")],
            options: [
                ProductOption(id: 3, productId: 2, name: "Size", values: ["M", "L"]),
                ProductOption(id: 4, productId: 2, name: "Color", values: ["blue", "white"])
            ]
        ),
        Product(
            id: 3, title: "Puma Sport", description: "",
            vendor: "Puma", productType: "Shoes", handle: "puma-sport",
            status: "active", tags: ["sport"],
            variants: [
                ProductVariant(
                    id: 3, productId: 3, title: "Default", price: "65.99", sku: "PS-003",
                    compareAtPrice: "89.99", inventoryQuantity: 15,
                    option1: nil, option2: nil, option3: nil, adminGraphqlApiId: nil
                )
            ],
            images: [ProductImage(id: 3, productId: 3, alt: "Puma Sport", src: "")],
            options: [
                ProductOption(id: 5, productId: 3, name: "Size", values: ["S", "M"]),
                ProductOption(id: 6, productId: 3, name: "Color", values: ["black"])
            ]
        )
    ]
}
