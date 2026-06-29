
// SearchDTO - Storefront GraphQL search response
struct SearchDTO: Codable {
    let totalCount: Int?                  // NEW: total results available
    let edges: [SearchEdgeDTO]?           // NEW: cursor-based pagination edges
    let pageInfo: PageInfoDTO?            // NEW: pagination info
    
    // For backward compatibility
    let query: String?
    let products: [ProductDTO]?
    let collections: [CategoryDTO]?
}

struct SearchEdgeDTO: Codable {          // NEW: represents one search result
    let cursor: String
    let node: ProductDTO
}

struct PageInfoDTO: Codable {            // NEW: pagination metadata
    let hasNextPage: Bool
    let hasPreviousPage: Bool?
    let endCursor: String?
    let startCursor: String?
}

