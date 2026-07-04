import Foundation

struct ShopifyRequest {

    private let adminToken: String

    init(
        adminToken: String = NetworkConstants.shopifyAccessToken
    ) {
        self.adminToken = adminToken
    }

    func buildREST(
        endpoint: ShopifyEndpoint,
        body: [String: Any]? = nil,
        queryParams: [String: String]? = nil
    ) throws -> URLRequest {

        guard var components = URLComponents(string: NetworkConstants.restBaseURL + endpoint.path) else {
            throw NetworkError.invalidURL
        }

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
        request.setValue("application/json", forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(NetworkConstants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(adminToken, forHTTPHeaderField: NetworkConstants.adminAccessTokenHeader)

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        return request
    }

}
