import Foundation

// Builds a URLRequest from any ShopifyEndpoint
struct ShopifyRequest {

    private let baseURL = "https://YOUR-STORE.myshopify.com/api/2024-01"
    private let token: String

    init(token: String) {
        self.token = token
    }

    func build(
        endpoint: ShopifyEndpoint,
        body: [String: Any]? = nil,
        queryParams: [String: String]? = nil
    ) throws -> URLRequest {

        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        // Attach query params if any
        if let params = queryParams {
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Storefront-Access-Token")

        // Attach body for POST/PUT requests
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        return request
    }
}
