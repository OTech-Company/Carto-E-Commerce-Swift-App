import Foundation

// Generic that decodes any Shopify response into T
struct ShopifyResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [ShopifyAPIError]?
}

struct GraphQLResponse<T: Decodable>: Decodable {
    let data: T?
    let errors: [GraphQLError]?

    struct GraphQLError: Decodable {
        let message: String
        let path: [String]?
    }
}

// error object returned in the response body
struct ShopifyAPIError: Decodable {
    let message: String
    let field: [String]?
    let code: String?
}

// Paginated list wrapper for endpoints that return collections
struct PaginatedResponse<T: Decodable>: Decodable {
    let items: [T]
    let pageInfo: PageInfo?
}

struct PageInfo: Decodable {
    let hasNextPage: Bool
    let endCursor: String?
}
