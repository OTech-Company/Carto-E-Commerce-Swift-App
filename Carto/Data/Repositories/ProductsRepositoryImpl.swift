//
//  ProductsRepositoryImpl.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

class ProductsRepositoryImpl: ProductsRepository {

    private let remoteDataSource: ProductsRemoteDataSource

    init(remoteDataSource: ProductsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getProductInfo(productId: Int) async throws -> ProductInfo {
        // 1. Fetch the flat REST DTO
        let dto = try await remoteDataSource.getProductInfo(productId: productId)

        // 2. Map directly to your clean ProductInfo domain entity
        return ProductInfo(from: dto)
    }
}
