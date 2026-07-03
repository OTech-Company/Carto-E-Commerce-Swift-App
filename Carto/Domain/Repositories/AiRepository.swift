//
//  AiRepository.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

protocol AIRepository {
    
    func runShoppingAssistant(
        userQuery: String,
        chatHistory: [GroqClient.TextMessage],
        availableCatalog: [Product]
    ) async throws -> AIChatResponse
    
 
    func compareProducts(productsToCompare: [Product]) async throws -> AIComparisonResponse
    
    func extractKeywordsFromImage(uiImageJPEGData: Data) async throws -> AIImageSearchResponse
    
    /// - Parameters:
    ///   - occasion: (e.g., "Summer Beach Wedding").
    ///   - catalogInventory: Available clothing or item collection.
    func generateOutfitSuggestions(for occasion: String, catalogInventory: [Product]) async throws -> AIOutfitResponse
    
    func generatePersonalizedInsights(purchasedProducts: [Product]) async throws -> AIShoppingInsightsResponse
}
