import Foundation

enum NetworkConstants {
    static let shopDomain = "https://mad46-ios-team6.myshopify.com"
    static let apiVersion = "2024-01"

    /// Shopify Admin REST base URL.
    static let restBaseURL = "\(shopDomain)/admin/api/\(apiVersion)"

    /// Shopify Storefront GraphQL endpoint.
    static let graphqlBaseURL = "\(shopDomain)/api/\(apiVersion)/graphql.json"

    /// Backwards-compatible alias for the existing network layer.
    static let baseURL = restBaseURL

    /// Admin API token used for REST requests.
    static let shopifyAccessToken = "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"

    /// Storefront token used for GraphQL requests.
    static let storefrontAccessToken = "YOUR_STOREFRONT_ACCESS_TOKEN_HERE"

    static let apiKey = "e09603df792c6c18ca12a848660db059"
    static let apiSecretKey = "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"

    static let timeoutInterval: TimeInterval = 30
    static let contentType = "application/json"
    static let adminAccessTokenHeader = "X-Shopify-Access-Token"
    static let storefrontAccessTokenHeader = "X-Shopify-Storefront-Access-Token"
    static let acceptHeader = "Accept"
}
