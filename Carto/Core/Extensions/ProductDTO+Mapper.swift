//
//  ProductDTO+Mapper.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//
import Foundation

extension Product {
    init(from dto: ProductDTO) {
        self.id = dto.id
        self.title = dto.title
        self.description = dto.bodyHtml ?? ""
        self.vendor = dto.vendor ?? "unknown brand"
        self.productType = dto.productType ?? ""
        self.handle = dto.handle ?? ""
        self.status = dto.status ?? "unknown"
        
        // Parse comma-separated tags layout safely into an array
        self.tags = dto.tags?
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty } ?? []
            
        self.variants = dto.variants?.map { ProductVariant(from: $0) } ?? []
        self.images = dto.images?.map { ProductImage(from: $0) } ?? []
        self.options = dto.options?.map { ProductOption(from: $0) } ?? []
    }
}

extension ProductVariant {
    init(from dto: ProductVariantDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.title = dto.title
        self.price = dto.price ?? "0.00"
        self.sku = dto.sku ?? ""
        self.compareAtPrice = dto.compareAtPrice
        self.inventoryQuantity = dto.inventoryQuantity ?? 0
    }
}

extension ProductImage {
    init(from dto: ProductImageDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.alt = dto.alt ?? ""
        self.src = dto.src ?? ""
    }
}

extension ProductOption {
    init(from dto: ProductOptionDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.name = dto.name
        self.values = dto.values ?? []
    }
}
