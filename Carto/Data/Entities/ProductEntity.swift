import Foundation

// MARK: - Core Domain Models
struct Product: Identifiable, Equatable {
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
    
    // UI Helpers
    var mainImageUrl: String? {
        images.first?.src
    }
    
    var displayPrice: String {
        guard let baselinePrice = variants.first?.price else { return "N/A" }
        return "$\(baselinePrice)"
    }
}

struct ProductVariant: Identifiable, Equatable {
    let id: Int
    let productId: Int
    let title: String
    let price: String
    let sku: String
    let compareAtPrice: String?
    let inventoryQuantity: Int
}

struct ProductImage: Identifiable, Equatable {
    let id: Int
    let productId: Int
    let alt: String
    let src: String
}

struct ProductOption: Identifiable, Equatable {
    let id: Int
    let productId: Int
    let name: String
    let values: [String]
}
