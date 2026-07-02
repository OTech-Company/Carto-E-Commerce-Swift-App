//
//  ProductInfo.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

struct ProductInfo: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let compareAtPrice: Double?
    let description: String
    let imageURL: String
    let sizes: [String]
    let colors: [String]

    var discountPercentage: Int? {
        guard let compareAtPrice,
              compareAtPrice > price else {
            return nil
        }

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
        description: "Lightweight running shoe with breathable mesh upper.",
        imageURL: "",
        sizes: ["S", "M", "L", "XL"],
        colors: ["black", "white", "red"]
    )

    static let mockProducts: [ProductInfo] = [
        ProductInfo(
            id: 1,
            title: "Nike Air Max",
            price: 89.99,
            compareAtPrice: 129.99,
            description: "",
            imageURL: "",
            sizes: ["S", "M", "L"],
            colors: ["black", "white"]
        ),
        ProductInfo(
            id: 2,
            title: "Adidas Runner",
            price: 74.99,
            compareAtPrice: 99.99,
            description: "",
            imageURL: "",
            sizes: ["M", "L"],
            colors: ["blue", "white"]
        ),
        ProductInfo(
            id: 3,
            title: "Puma Sport",
            price: 65.99,
            compareAtPrice: 89.99,
            description: "",
            imageURL: "",
            sizes: ["S", "M"],
            colors: ["black"]
        ),
        ProductInfo(
            id: 4,
            title: "New Balance",
            price: 95.99,
            compareAtPrice: 129.99,
            description: "",
            imageURL: "",
            sizes: ["L", "XL"],
            colors: ["gray"]
        ),
        ProductInfo(
            id: 5,
            title: "Nike Revolution",
            price: 79.99,
            compareAtPrice: 109.99,
            description: "",
            imageURL: "",
            sizes: ["S", "M", "L"],
            colors: ["red"]
        ),
        ProductInfo(
            id: 6,
            title: "Adidas Ultra",
            price: 119.99,
            compareAtPrice: 149.99,
            description: "",
            imageURL: "",
            sizes: ["M", "L", "XL"],
            colors: ["white"]
        )
    ]
}

extension ProductInfo {
    init(from dto: ProductDTO) {
        // Map ID safely as a String representation
        if let numericId = dto.id {
                    self.id = String(numericId)
                } else {
                    self.id = "0" 
                }
        self.title = dto.title ?? "Untitled Product"
        
        // Extract the first variant for price calculations
        let firstVariant = dto.variants?.first
        
        // Parse baseline price string (e.g. "30.99") into Double safely
        let rawPrice = Double(firstVariant?.price ?? "") ?? 0.0
        self.price = rawPrice
        
        // Calculate dynamic discount percentage if compareAtPrice exists
        if let compareStr = firstVariant?.compareAtPrice,
           let comparePrice = Double(compareStr), comparePrice > rawPrice {
            let savings = ((comparePrice - rawPrice) / comparePrice) * 100
            self.discount = "\(Int(round(savings)))% OFF"
        } else {
            self.discount = ""
        }
        
        // Fallback placeholder image URL if list is empty
        self.imageURL = dto.images?.first?.src ?? ""
        
        // Dynamic Extraction of Variant Selection Attributes
        self.sizes = dto.options?
            .first(where: { $0.name.lowercased() == "size" })?.values ?? []
            
        self.colors = dto.options?
            .first(where: { $0.name.lowercased() == "color" })?.values ?? []
    }
}
