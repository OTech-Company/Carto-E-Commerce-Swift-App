//
//  ProductsInfoUseCase.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

struct ProductsInfoUseCase{
    
    private let repository: ProductsInfoRepository
    
    init(repository: ProductsInfoRepository) {
        self.repository = repository
    }

    func execute(productId: String) async throws -> ProductInfo {
        try await repository.getProductsInfo(productId: productId)
    }
    
}
