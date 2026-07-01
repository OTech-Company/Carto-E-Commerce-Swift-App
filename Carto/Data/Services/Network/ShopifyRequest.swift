import Foundation

struct ShopifyRequest {

    private let adminToken: String
    private let storefrontToken: String

    init(
        adminToken: String = NetworkConstants.shopifyAccessToken,
        storefrontToken: String = NetworkConstants.storefrontAccessToken
    ) {
        self.adminToken = adminToken
        self.storefrontToken = storefrontToken
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

    func buildGraphQL<QueryVariables: Encodable>(
        operationName: String? = nil,
        query: String,
        variables: QueryVariables? = nil,
        useStorefrontToken: Bool = false
    ) throws -> URLRequest {

        guard let url = URL(string: NetworkConstants.graphqlBaseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(NetworkConstants.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(useStorefrontToken ? storefrontToken : adminToken, forHTTPHeaderField: NetworkConstants.storefrontAccessTokenHeader)

        let payload = GraphQLRequestPayload(
            query: query,
            variables: variables,
            operationName: operationName
        )
        request.httpBody = try JSONEncoder().encode(payload)

        return request
    }
}

private struct GraphQLRequestPayload<Variables: Encodable>: Encodable {
    let query: String
    let variables: Variables?
    let operationName: String?
}
