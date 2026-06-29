import Foundation
import Combine

final class ShopifyAPIClient {

    static let shared = ShopifyAPIClient()
    private let session: URLSession
    private let requestBuilder: ShopifyRequest

    private init() {
        self.session = .shared
        self.requestBuilder = ShopifyRequest()
    }

    func requestREST<T: Decodable>(
        endpoint: ShopifyEndpoint,
        body: [String: Any]? = nil,
        queryParams: [String: String]? = nil
    ) async throws -> T {

        let urlRequest = try requestBuilder.buildREST(
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

    func requestGraphQL<ResponseData: Decodable, Variables: Encodable>(
        query: String,
        variables: Variables? = nil,
        operationName: String? = nil,
        useStorefrontToken: Bool = false,
        responseType: ResponseData.Type = ResponseData.self
    ) async throws -> ResponseData {

        let urlRequest = try requestBuilder.buildGraphQL(
            operationName: operationName,
            query: query,
            variables: variables,
            useStorefrontToken: useStorefrontToken
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
            let decoded = try JSONDecoder().decode(GraphQLResponse<ResponseData>.self, from: data)

            if let errors = decoded.errors, !errors.isEmpty {
                throw NetworkError.graphQL(errors.map { $0.message })
            }

            guard let payload = decoded.data else {
                throw NetworkError.decodingFailed(DecodingError.valueNotFound(
                    ResponseData.self,
                    DecodingError.Context(codingPath: [], debugDescription: "GraphQL response had no data.")
                ))
            }

            return payload
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
