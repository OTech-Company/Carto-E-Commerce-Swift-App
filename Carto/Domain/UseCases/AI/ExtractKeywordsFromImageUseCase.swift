//
//  ExtractKeywordsFromImageUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

class ExtractKeywordsFromImageUseCase {
    private let repository: AIRepository
    
    init(repository: AIRepository) {
        self.repository = repository
    }
    
    func execute(uiImageJPEGData: Data?) async throws -> AIImageSearchResponse {
        // Business Rule: Validate presence of structural asset binary before payload delivery
        guard let validData = uiImageJPEGData, !validData.isEmpty else {
            throw NSError(domain: "VisionUseCase", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid or corrupt image buffer data profile."])
        }
        
        return try await repository.extractKeywordsFromImage(uiImageJPEGData: validData)
    }
}
