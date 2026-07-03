//
//  CompareProductsUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class CompareProductsUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(productsToCompare: [Product]) async throws -> AIComparisonResponse {
        // Business Rule: Ensure there are enough items to actually perform a comparison matrix
        guard productsToCompare.count >= 2 else {
            throw NSError(domain: "ComparisonUseCase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Select at least 2 products to run comparison metrics."])
        }
        
        return try await repository.compareProducts(productsToCompare: productsToCompare)
    }
}
