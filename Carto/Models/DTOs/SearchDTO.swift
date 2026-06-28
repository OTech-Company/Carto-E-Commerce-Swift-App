
// SearchDTO
struct SearchDTO: Codable {
    let query: String
    let products: [ProductDTO]?
    let collections: [CategoryDTO]?
}
