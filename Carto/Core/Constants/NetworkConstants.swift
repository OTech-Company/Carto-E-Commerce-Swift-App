import Foundation

enum NetworkConstants {
    // Dynamically populated from environment configuration
    static let shopDomain = AppEnvironment.shopDomain
    static let apiVersion = AppEnvironment.apiVersion
    static let shopifyAccessToken = AppEnvironment.shopifyAccessToken
    static let storefrontAccessToken = AppEnvironment.storefrontAccessToken
    static let storePassword = AppEnvironment.storePassword
    static let apiKey = AppEnvironment.apiKey
    static let apiSecretKey = AppEnvironment.apiSecretKey

    /// Shopify Admin REST base URL.
    static let restBaseURL = "https://\(shopDomain)/admin/api/\(apiVersion)"

    /// Shopify Storefront GraphQL endpoint.
    static let graphqlBaseURL = "https://\(shopDomain)/api/\(apiVersion)/graphql.json"

    /// Backwards-compatible alias for the existing network layer.
    static let baseURL = restBaseURL

    // Standard configurations (These are completely safe to keep here as open text code constants)
    static let timeoutInterval: TimeInterval = 30
    static let contentType = "application/json"
    static let adminAccessTokenHeader = "X-Shopify-Access-Token"
    static let storefrontAccessTokenHeader = "X-Shopify-Storefront-Access-Token"
    static let acceptHeader = "Accept"
    static let contentTypeHeader = "Content-Type"
}
