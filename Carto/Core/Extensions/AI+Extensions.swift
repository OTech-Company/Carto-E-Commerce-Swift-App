//
//  AI+Extensions.swift
//  Carto
//
//  Created by Osama Hosam on 03/07/2026.
//

import Foundation

extension GroqClient {
    
    // Helper to streamline inventory to avoid context blowup
    private func simplifiedCatalogJSON(_ catalog: [Product]) -> String {
        let simplified = catalog.map { [
            "id": $0.id,
            "title": $0.title,
            "vendor": $0.vendor,
            "type": $0.productType,
            "price": $0.displayPrice,
            "tags": $0.tags
        ] as [String : Any] }
        if let data = try? JSONSerialization.data(withJSONObject: simplified),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "[]"
    }

    // Strips out markdown code blocks (```json ... ```) or conversational fluff if the LLM includes it
    private func sanitizeAndConvertJSON(_ rawString: String) -> Data {
        var cleaned = rawString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove opening markdown fences if present
        if cleaned.hasPrefix("```json") {
            cleaned = String(cleaned.dropFirst(7))
        } else if cleaned.hasPrefix("```") {
            cleaned = String(cleaned.dropFirst(3))
        }
        
        // Remove closing markdown fences if present
        if cleaned.hasSuffix("```") {
            cleaned = String(cleaned.dropLast(3))
        }
        
        // Clean up any remaining trailing whitespaces
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return Data(cleaned.utf8)
    }

    // 1. AI Shopping Assistant (Smart Chat)
    func runShoppingAssistantJSON(userQuery: String, chatHistory: [TextMessage], availableCatalog: [Product]) async throws -> AIChatResponse {
        let snapshot = simplifiedCatalogJSON(availableCatalog)
        let systemPrompt = """
        You are a shopping assistant. Help the user but respond ONLY with a raw JSON object matching this schema:
        {
          "replyText": "Your natural language response here.",
          "recommendedProductIds": [1, 2]
        }
        Inventory: \(snapshot)
        """
        
        var messages = [TextMessage(role: "system", content: systemPrompt)]
        messages.append(contentsOf: chatHistory)
        messages.append(TextMessage(role: "user", content: userQuery))
        
        let rawText = try await processText(messages: messages)
        let sanitizedData = sanitizeAndConvertJSON(rawText)
        return try JSONDecoder().decode(AIChatResponse.self, from: sanitizedData)
    }
    
    // 2. AI Product Comparison
    func compareProductsJSON(productsToCompare: [Product]) async throws -> AIComparisonResponse {
        let snapshot = simplifiedCatalogJSON(productsToCompare)
        let productIds = productsToCompare.map { String($0.id) }.joined(separator: ", ")
        
        let systemPrompt = """
        Compare these products. Respond ONLY with a raw JSON object matching this schema. Ensure the keys inside the values object match the product IDs exactly (\(productIds)).
        Schema:
        {
          "summary": "High level summary overview",
          "comparisons": [
            { "metricName": "Price", "values": {"1": "$85.00", "2": "$160.00"} },
            { "metricName": "Material", "values": {"1": "Canvas", "2": "Mesh/Carbon"} }
          ],
          "verdict": "Final buying advice."
        }
        Products: \(snapshot)
        """
        
        let messages = [TextMessage(role: "system", content: systemPrompt), TextMessage(role: "user", content: "Compare items")]
        let rawText = try await processText(messages: messages)
        let sanitizedData = sanitizeAndConvertJSON(rawText)
        return try JSONDecoder().decode(AIComparisonResponse.self, from: sanitizedData)
    }
    
    // 3. AI Image Search
    func extractKeywordsFromImageJSON(uiImageJPEGData: Data) async throws -> AIImageSearchResponse {
        let base64String = uiImageJPEGData.base64EncodedString()
        let prompt = """
        Analyze this image. Respond ONLY with a raw JSON object matching this schema:
        {
          "keywords": ["hoodie", "streetwear", "black"],
          "detectedCategories": ["Apparel", "Sweatshirts"]
        }
        """
        let rawText = try await processImage(prompt: prompt, base64Image: base64String)
        let sanitizedData = sanitizeAndConvertJSON(rawText)
        return try JSONDecoder().decode(AIImageSearchResponse.self, from: sanitizedData)
    }
    
    // 4. AI Outfit Generator
    func generateOutfitSuggestionsJSON(for occasion: String, catalogInventory: [Product]) async throws -> AIOutfitResponse {
        let snapshot = simplifiedCatalogJSON(catalogInventory)
        let systemPrompt = """
        Build an outfit for "\(occasion)". Respond ONLY with a raw JSON object matching this schema:
        {
          "outfitTitle": "Athleisure Wedding Core",
          "stylingReasoning": "Styling breakdown details here...",
          "itemIdsInBundle": [1, 2]
        }
        Inventory: \(snapshot)
        """
        
        let messages = [TextMessage(role: "system", content: systemPrompt), TextMessage(role: "user", content: "Assemble bundle")]
        let rawText = try await processText(messages: messages)
        let sanitizedData = sanitizeAndConvertJSON(rawText)
        return try JSONDecoder().decode(AIOutfitResponse.self, from: sanitizedData)
    }
    
    // 5. AI Shopping Insights
    func generatePersonalizedInsightsJSON(purchasedProducts: [Product]) async throws -> AIShoppingInsightsResponse {
        let snapshot = simplifiedCatalogJSON(purchasedProducts)
        let systemPrompt = """
        Analyze purchase metrics. Respond ONLY with a raw JSON object matching this schema:
        {
          "insights": [
            { "title": "Brand Fan", "meaning": "You buy from Trailhead a lot.", "suggestedNextSteps": "Look at their new drop." }
          ]
        }
        History: \(snapshot)
        """
        
        let messages = [TextMessage(role: "system", content: systemPrompt), TextMessage(role: "user", content: "Analyze profile")]
        let rawText = try await processText(messages: messages)
        let sanitizedData = sanitizeAndConvertJSON(rawText)
        return try JSONDecoder().decode(AIShoppingInsightsResponse.self, from: sanitizedData)
    }
}
