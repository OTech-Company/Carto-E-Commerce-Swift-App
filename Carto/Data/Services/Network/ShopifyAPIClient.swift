import Foundation
import Combine

final class ShopifyAPIClient {

    static let shared = ShopifyAPIClient()
    private let session: URLSession
    private let requestBuilder: ShopifyRequest
    private let enableLogging = true

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

        if enableLogging {
            debugPrint("---- REST Request ----")
            debugPrint(urlRequest.httpMethod ?? "", urlRequest.url?.absoluteString ?? "")
            debugPrint("Headers:", urlRequest.allHTTPHeaderFields ?? [:])
            if let body = urlRequest.httpBody, let s = String(data: body, encoding: .utf8) {
                debugPrint("Body:", s)
            }
        }

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

        if enableLogging {
            if let s = String(data: data, encoding: .utf8) {
                debugPrint("---- REST Response (status:\(http.statusCode)) ----")
                debugPrint(s)
            }
        }

        do {
            let decoder = JSONDecoder()
            // Accept snake_case keys commonly returned by REST admin endpoints
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            // Attempt a best-effort fallback: if the server wrapped the payload in a
            // top-level key (e.g. { "products": [...] } or { "product": { ... } }),
            // try to extract the first value and decode T from it.
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
               let dict = jsonObj as? [String: Any] {
                for (_, value) in dict {
                    if JSONSerialization.isValidJSONObject(value),
                       let vdata = try? JSONSerialization.data(withJSONObject: value, options: []) {
                        if let decoded = try? JSONDecoder().decode(T.self, from: vdata) {
                            if enableLogging {
                                debugPrint("Decoded T from first-level wrapper key")
                            }
                            return decoded
                        }
                    }
                }
            }

            if enableLogging {
                debugPrint("Decoding failed for REST response:", error)
                if let s = String(data: data, encoding: .utf8) {
                    debugPrint("Raw response:", s)
                }
            }

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

        if enableLogging {
            debugPrint("---- GraphQL Request ----")
            debugPrint(urlRequest.httpMethod ?? "", urlRequest.url?.absoluteString ?? "")
            debugPrint("Headers:", urlRequest.allHTTPHeaderFields ?? [:])
            if let body = urlRequest.httpBody, let s = String(data: body, encoding: .utf8) {
                debugPrint("Body:", s)
            }
        }

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

        if enableLogging {
            if let s = String(data: data, encoding: .utf8) {
                debugPrint("---- GraphQL Response (status:\(http.statusCode)) ----")
                debugPrint(s)
            }
        }

        do {
            let decoder = JSONDecoder()
            // GraphQL responses generally use camelCase matching Swift property names,
            // but convertFromSnakeCase is harmless if snake_case appears.
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let decoded = try decoder.decode(GraphQLResponse<ResponseData>.self, from: data)

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
