struct ProductEntity {
    let id: String
    let title: String
    let description: String
    let brand: String
    let category: String
    let price: Double
    let compareAtPrice: Double?
    let images: [String]          // image URLs
    let variants: [VariantEntity]
    let tags: [String]
    let rating: Double?
    let reviewCount: Int
}


