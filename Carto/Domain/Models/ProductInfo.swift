//
//  ProductInfo.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

struct ProductInfo{
    let id: String
    let title: String
    let price: Double
    let discount: String
    let imageURL: String
    let sizes: [String]
    let colors: [String]
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
