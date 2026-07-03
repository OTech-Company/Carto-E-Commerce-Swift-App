//
//  GenerateOutfitSuggestionsUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class GenerateOutfitSuggestionsUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(for occasion: String, catalogInventory: [Product]) async throws -> AIOutfitResponse {
        guard !occasion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "OutfitUseCase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Occasion theme cannot be empty."])
        }
        
        return try await repository.generateOutfitSuggestions(for: occasion, catalogInventory: catalogInventory)
    }
}
