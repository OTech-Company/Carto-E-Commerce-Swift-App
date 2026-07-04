//
//  GraphQLStorefrontResponse.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

struct GraphQLStorefrontResponse<Data: Decodable>: Decodable {
    let data: Data?
    let errors: [GraphQLError]?
}

struct GraphQLError: Decodable {
    let message: String
    let extensions: GraphQLErrorExtensions?
}

struct GraphQLErrorExtensions: Decodable {
    let code: String?
}
