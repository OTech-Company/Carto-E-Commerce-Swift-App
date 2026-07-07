//
//  AdminGraphQLClient.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//


import Foundation

enum AdminAPIError: LocalizedError {
    case invalidURL
    case invalidConfiguration
    case requestFailed(Int)
    case decodingFailed(String)
    case graphQL([String])

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid Shopify Admin API URL."
        case .invalidConfiguration: return "Missing Shopify Admin API configuration (shop domain / access token)."
        case .requestFailed(let code): return "Admin API request failed (\(code))."
        case .decodingFailed(let reason): return "Failed to decode Admin API response: \(reason)"
        case .graphQL(let messages): return messages.joined(separator: "\n")
        }
    }
}

protocol AdminGraphQLClient {
    func request<Response: Decodable, Variables: Encodable>(
        _ request: GraphQLRequest<Variables>
    ) async throws -> Response
}

final class ShopifyAdminGraphQLClient: AdminGraphQLClient {

    static let shared = ShopifyAdminGraphQLClient()

    private let session: URLSession
    private let shopDomain: String
    private let apiVersion: String
    private let accessToken: String

    private init(session: URLSession = .shared) {
        self.session = session
        self.shopDomain = NetworkConstants.shopDomain
        self.apiVersion = NetworkConstants.apiVersion
        self.accessToken = NetworkConstants.shopifyAccessToken
    }

    func request<Response: Decodable, Variables: Encodable>(
        _ request: GraphQLRequest<Variables>
    ) async throws -> Response {
        guard !shopDomain.isEmpty, !accessToken.isEmpty else {
            throw AdminAPIError.invalidConfiguration
        }
        guard let url = URL(string: "https://\(shopDomain)/admin/api/\(apiVersion)/graphql.json") else {
            throw AdminAPIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(NetworkConstants.contentType, forHTTPHeaderField: NetworkConstants.contentTypeHeader)
        urlRequest.setValue(accessToken, forHTTPHeaderField: NetworkConstants.adminAccessTokenHeader)
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw AdminAPIError.requestFailed((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let envelope = try JSONDecoder().decode(Envelope<Response>.self, from: data)
        if let errors = envelope.errors, !errors.isEmpty {
            throw AdminAPIError.graphQL(errors.map { $0.message })
        }
        guard let payload = envelope.data else {
            throw AdminAPIError.decodingFailed("Admin API response had no data")
        }
        return payload
    }
}

struct Envelope<Response: Decodable>: Decodable {
    let data: Response?
    let errors: [GraphQLError]?

    struct GraphQLError: Decodable {
        let message: String
    }
}
