//
//  SharedStorefrontModels.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Shared GraphQL Models

struct StorefrontConnection<Node: Decodable>: Decodable {
    let edges: [StorefrontEdge<Node>]
    let pageInfo: StorefrontPageInfo

    var nodes: [Node] {
        edges.map(\.node)
    }
}

struct StorefrontEdge<Node: Decodable>: Decodable {
    let node: Node
}

struct StorefrontPageInfo: Decodable {
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let startCursor: String?
    let endCursor: String?
}

struct StorefrontMoney: Decodable {
    let amount: String
    let currencyCode: String
}

struct StorefrontImage: Decodable {
    let id: String?
    let url: String
    let altText: String?
}

struct StorefrontMetafield: Decodable {
    let value: String
}
