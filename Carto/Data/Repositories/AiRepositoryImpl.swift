//
//  AiRepositoryImpl.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class AIRepositoryImpl: AIRepository {
    
    private let client: GroqClient
    
    init(client: GroqClient) {
        self.client = client
    }
    
    func runShoppingAssistant(
        userQuery: String,
        chatHistory: [GroqClient.TextMessage],
        availableCatalog: [Product]
    ) async throws -> AIChatResponse {
        return try await client.runShoppingAssistantJSON(
            userQuery: userQuery,
            chatHistory: chatHistory,
            availableCatalog: availableCatalog
        )
    }
    
    func compareProducts(productsToCompare: [Product]) async throws -> AIComparisonResponse {
        return try await client.compareProductsJSON(productsToCompare: productsToCompare)
    }
    
    func extractKeywordsFromImage(uiImageJPEGData: Data) async throws -> AIImageSearchResponse {
        return try await client.extractKeywordsFromImageJSON(uiImageJPEGData: uiImageJPEGData)
    }
    
    func generateOutfitSuggestions(for occasion: String, catalogInventory: [Product]) async throws -> AIOutfitResponse {
        return try await client.generateOutfitSuggestionsJSON(for: occasion, catalogInventory: catalogInventory)
    }
    
    func generatePersonalizedInsights(purchasedProducts: [Product]) async throws -> AIShoppingInsightsResponse {
        return try await client.generatePersonalizedInsightsJSON(purchasedProducts: purchasedProducts)
    }
}
