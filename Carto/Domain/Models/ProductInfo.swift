//
//  ProductInfo.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

struct ProductInfo {
    let id: Int
    let title: String
    let price: Double
    let compareAtPrice: Double?
    let description: String
    let imageURL: String
    let sizes: [String]
    let colors: [String]

    var discountPercentage: Int? {
        guard let compareAtPrice = compareAtPrice, compareAtPrice > price else { return nil }
        let discount = (compareAtPrice - price) / compareAtPrice * 100
        return Int(discount.rounded())
    }
}

extension ProductInfo {
    static let mock = ProductInfo(
        id: 1,
        title: "Nike Air Max",
        price: 89.99,
        compareAtPrice: 129.99,
        description: "Lightweight running shoe with breathable mesh upper and responsive cushioning, built for everyday comfort and long-distance runs.Lightweight running shoe with breathable mesh upper and responsive cushioning, built for everyday comfort and long-distance runs.",
        imageURL: "https://cdn.shopify.com/example.png",
        sizes: ["S", "M", "L", "XL"],
        colors: ["black", "white", "red"]
    )
}
