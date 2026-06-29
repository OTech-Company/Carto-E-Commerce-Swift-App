//
//  ProductsRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

protocol ProductsRemoteDataSource {
    func getProductInfo(productId: String) async throws -> ProductDTO
}
