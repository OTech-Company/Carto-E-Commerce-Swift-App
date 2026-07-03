//
//  ProductsInfoUseCase.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

protocol ProductUseCaseProtocol{
    func execute(productId: Int) async throws -> Product
    func execute(brandId: Int) async throws -> [Product]
    func execute() async throws -> [Product]
}

struct ProductsUseCase: ProductUseCaseProtocol {

    private let repository: ProductsRepository
    
    init(repository: ProductsRepository) {
        self.repository = repository
    }

    func execute(productId: Int) async throws -> Product {
        return try await repository.getProductInfo(productId: productId)
    }
    
    func execute(brandId: Int) async throws -> [Product] {
        return try await repository.getProductsByBrand(brandId: brandId)
    }
    
    func execute() async throws -> [Product] {
        return try await repository.getAllProducts()
    }
    
}
