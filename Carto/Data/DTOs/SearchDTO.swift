//
//  SearchDTO.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

// MARK: - SearchDTO
struct SearchDTO: Decodable {
    let totalCount: Int?
    let edges: [SearchEdgeDTO]?
    let pageInfo: PageInfoDTO?
    
    // For backward compatibility
    let query: String?
    let products: [ProductDTO]?
    let collections: [CategoryDTO]?
}

// MARK: - SearchEdgeDTO
struct SearchEdgeDTO: Decodable {
    let cursor: String
    let node: ProductDTO
}

// MARK: - PageInfoDTO
struct PageInfoDTO: Decodable {
    let hasNextPage: Bool
    let hasPreviousPage: Bool?
    let endCursor: String?
    let startCursor: String?
}
