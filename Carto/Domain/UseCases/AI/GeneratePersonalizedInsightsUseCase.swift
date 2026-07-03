//
//  GeneratePersonalizedInsightsUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class GeneratePersonalizedInsightsUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(purchasedProducts: [Product]) async throws -> AIShoppingInsightsResponse {
        // Business Rule: If user has zero purchase history records, return immediate empty state insights data
        guard !purchasedProducts.isEmpty else {
            return AIShoppingInsightsResponse(insights: [
                .init(title: "Welcome to Carto!", meaning: "You haven't made any purchases yet.", suggestedNextSteps: "Explore the catalog or chat with our assistant for ideas.")
            ])
        }
        
        return try await repository.generatePersonalizedInsights(purchasedProducts: purchasedProducts)
    }
}
