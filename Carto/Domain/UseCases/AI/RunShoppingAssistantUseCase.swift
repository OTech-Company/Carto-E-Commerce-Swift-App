//
//  RunShoppingAssistantUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class RunShoppingAssistantUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(
        userQuery: String,
        chatHistory: [GroqClient.TextMessage],
        availableCatalog: [Product]
    ) async throws -> AIChatResponse {
        // Business Rule: Reject empty requests early to save token context bandwidth
        guard !userQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "AssistantUseCase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Query cannot be blank."])
        }
        
        return try await repository.runShoppingAssistant(
            userQuery: userQuery,
            chatHistory: chatHistory,
            availableCatalog: availableCatalog
        )
    }
}
