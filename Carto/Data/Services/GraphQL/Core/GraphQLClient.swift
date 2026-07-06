//
//  GraphQLClient.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

protocol GraphQLClient {
    func request<Response: Decodable, Variables: Encodable>(
        _ request: GraphQLRequest<Variables>
    ) async throws -> Response
}

struct GraphQLRequest<Variables: Encodable>: Encodable {
    let query: String
    let variables: Variables?
    let operationName: String?

    init(query: String, variables: Variables? = nil, operationName: String? = nil) {
        self.query = query
        self.variables = variables
        self.operationName = operationName
    }
}

struct EmptyVariables: Encodable {}
