//
//  ProductsInfoRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

class ProductsRepositoryImpl: ProductsRepositoryProtocol {

    private let remoteDataSource: ProductsRemoteDataSource

    init(remoteDataSource: ProductsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getProductInfo(productId: String) async throws -> ProductInfo {

        let dto = try await remoteDataSource.getProductInfo(productId: productId)

        return dto.toDomain()
    }
}
