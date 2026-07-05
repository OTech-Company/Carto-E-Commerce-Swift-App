//
//  GraphQLStorefrontRequestBuilder.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

struct GraphQLStorefrontRequestBuilder {

    private let storefrontToken: String
    private let urlString : String
    
    init() {
        storefrontToken = NetworkConstants.storefrontAccessToken
        urlString = NetworkConstants.graphqlBaseURL
    }

    func buildStorefrontRequest<Variables: Encodable>(
        query: String,
        variables: Variables? = nil,
        operationName: String? = nil
    ) throws -> URLRequest {
        
        guard let url = URL(string: urlString) else {
            throw GraphQLStorefrontNetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(NetworkConstants.contentType, forHTTPHeaderField: NetworkConstants.acceptHeader)
        request.setValue(NetworkConstants.contentType, forHTTPHeaderField: NetworkConstants.contentTypeHeader)
        request.setValue(storefrontToken, forHTTPHeaderField: NetworkConstants.storefrontAccessTokenHeader)

        let payload = GraphQLPayload(
            query: query,
            variables: variables,
            operationName: operationName
        )
        request.httpBody = try JSONEncoder().encode(payload)

        return request
    }
}

private struct GraphQLPayload<Variables: Encodable>: Encodable {
    let query: String
    let variables: Variables?
    let operationName: String?
}
