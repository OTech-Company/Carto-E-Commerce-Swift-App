import Foundation
import Combine

// Central network client — all features call this, nothing else
final class ShopifyAPIClient {

    static let shared = ShopifyAPIClient()
    private let session: URLSession
    private let requestBuilder: ShopifyRequest

    private init() {
        self.session = .shared
        self.requestBuilder = ShopifyRequest(token: Constants.shopifyAccessToken)
    }

    // Async/await — primary API for all ViewModels
    func request<T: Decodable>(
        endpoint: ShopifyEndpoint,
        body: [String: Any]? = nil,
        queryParams: [String: String]? = nil
    ) async throws -> T {

        let urlRequest = try requestBuilder.build(
            endpoint: endpoint,
            body: body,
            queryParams: queryParams
        )

        let (data, response) = try await session.data(for: urlRequest)

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.unknown(URLError(.badServerResponse))
        }

        switch http.statusCode {
        case 200...299: break
        case 401:       throw NetworkError.unauthorized
        case 404:       throw NetworkError.notFound
        case 500...:    throw NetworkError.serverError
        default:        throw NetworkError.requestFailed(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
