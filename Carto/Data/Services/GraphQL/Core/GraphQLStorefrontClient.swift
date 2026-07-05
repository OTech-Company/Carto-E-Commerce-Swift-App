//
//  GraphQLStorefrontClient.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

final class GraphQLStorefrontClient: GraphQLClient {

    static let shared = GraphQLStorefrontClient()

    private let session: URLSession
    private let requestBuilder: GraphQLStorefrontRequestBuilder
    private let enableLogging = false

    init(
        session: URLSession = .shared
    ) {
        self.session = session
        self.requestBuilder = GraphQLStorefrontRequestBuilder()
    }

    func request<Response: Decodable, Variables: Encodable>(
        _ request: GraphQLRequest<Variables>
    ) async throws -> Response {
        let urlRequest = try requestBuilder.buildStorefrontRequest(
            query: request.query,
            variables: request.variables,
            operationName: request.operationName
        )

        if enableLogging {
            debugPrint("---- GraphQL Request ----")
            debugPrint(urlRequest.httpMethod ?? "", urlRequest.url?.absoluteString ?? "")
            debugPrint("Headers:", urlRequest.allHTTPHeaderFields ?? [:])
            if let body = urlRequest.httpBody, let s = String(data: body, encoding: .utf8) {
                debugPrint("Body:", s)
            }
        }

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let http = response as? HTTPURLResponse else {
                throw GraphQLStorefrontNetworkError.unknown(URLError(.badServerResponse))
            }

            switch http.statusCode {
            case 200...299:
                break
            case 401:
                throw GraphQLStorefrontNetworkError.unauthorized
            case 404:
                throw GraphQLStorefrontNetworkError.notFound
            case 500...:
                throw GraphQLStorefrontNetworkError.serverError
            default:
                throw GraphQLStorefrontNetworkError.requestFailed(http.statusCode)
            }

            if enableLogging {
                if let s = String(data: data, encoding: .utf8) {
                    debugPrint("---- GraphQL Response (status:\(http.statusCode)) ----")
                    debugPrint(s)
                }
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decoded = try decoder.decode(GraphQLStorefrontResponse<Response>.self, from: data)

                if let errors = decoded.errors, !errors.isEmpty {
                    throw GraphQLStorefrontNetworkError.graphQLError(errors.map { $0.message })
                }

                guard let payload = decoded.data else {
                    throw GraphQLStorefrontNetworkError.decodingFailed(
                        DecodingError.valueNotFound(
                            Response.self,
                            DecodingError.Context(
                                codingPath: [],
                                debugDescription: "GraphQL response had no data."
                            )
                        )
                    )
                }

                return payload
            } catch let error as GraphQLStorefrontNetworkError {
                throw error
            } catch {
                throw GraphQLStorefrontNetworkError.decodingFailed(error)
            }
        } catch let error as URLError {
            if enableLogging {
                debugPrint("❌ GraphQL URLError: \(error.localizedDescription) (code: \(error.code.rawValue))")
                debugPrint("URL: \(urlRequest.url?.absoluteString ?? "invalid")")
            }
            if error.code == .timedOut {
                throw GraphQLStorefrontNetworkError.timeout
            }
            if error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
                throw GraphQLStorefrontNetworkError.noInternet
            }
            throw GraphQLStorefrontNetworkError.unknown(error)
        } catch {
            throw error
        }
    }
}
