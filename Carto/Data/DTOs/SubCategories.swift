//
//  SubCategories.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation

// MARK: - Core Subcategory Domain Model
struct Subcategory {
    let name: String
    let imageUrl: String?
}

struct CategoryProductsResponse: Decodable {
    let products: [ProductDTO]?
}
