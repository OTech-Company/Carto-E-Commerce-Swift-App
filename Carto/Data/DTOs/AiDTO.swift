//
//  AiDTO.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation


struct AIChatResponse: Codable {
    let replyText: String
    let recommendedProductIds: [Int] // Array of matching product IDs from your catalog
}

struct AIComparisonResponse: Codable {
    let summary: String
    let comparisons: [ProductComparisonMetric]
    let verdict: String
    
    struct ProductComparisonMetric: Codable {
        let metricName: String // e.g., "Price", "Material", "Best For"
        let values: [String: String] // e.g., ["1": "$85.00", "2": "$160.00"] (Key is Product ID)
    }
}

struct AIImageSearchResponse: Codable {
    let keywords: [String]
    let detectedCategories: [String]
}

//Bundle Generator Response
struct AIOutfitResponse: Codable {
    let outfitTitle: String
    let stylingReasoning: String
    let itemIdsInBundle: [Int] // Strict array of product IDs that form the outfit
}

struct AIShoppingInsightsResponse: Codable {
    let insights: [DashboardInsight]
    
    struct DashboardInsight: Codable {
        let title: String
        let meaning: String
        let suggestedNextSteps: String
    }
}
