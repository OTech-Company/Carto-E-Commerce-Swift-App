
// CategoryDTO - represents Collections in Shopify
struct CategoryDTO: Codable {
    let id: String
    let title: String
    let handle: String?                  // URL slug - optional for some queries
    let description: String?              // NEW: collection description
    let image: ImageDTO?
    let products: [ProductDTO]?           // NEW: products in this collection
    let productsCount: Int?
}

