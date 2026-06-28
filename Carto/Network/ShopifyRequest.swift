import Foundation

struct ShopifyRequest {

    private let baseURL = NetworkConstants.baseURL
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
        request.setValue(NetworkConstants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: NetworkConstants.accessTokenHeader)

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }

        return request
    }
}
