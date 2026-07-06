//
//  ChatMessageDisplay.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import SwiftUI
import Combine

// MARK: - Presentation UI State Models
struct ChatMessageDisplay: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let recommendedProductIds: [Int]
}

// MARK: - Chat Assistant ViewModel
@MainActor
final class CartoAIAssistantViewModel: ObservableObject {
    @Published var messages: [ChatMessageDisplay] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    let suggestionChips = ["Find running shoes", "Track my order", "Suggest gifts", "Sale Items", "New arrivals"]
    
    // Dependencies injected strictly via Domain Use Case Protocols
    private let runShoppingAssistantUseCase: RunShoppingAssistantUseCase
    
    init(runShoppingAssistantUseCase: RunShoppingAssistantUseCase) {
        self.runShoppingAssistantUseCase = runShoppingAssistantUseCase
        setupDefaultConversations()
    }
    
    private func setupDefaultConversations() {
        messages = [
            ChatMessageDisplay(text: "Find running shoes", isUser: true, recommendedProductIds: []),
            ChatMessageDisplay(text: "Hi! I'm your smart shopping assistant. How can I help you find the perfect product today?", isUser: false, recommendedProductIds: [])
        ]
    }
    
    func appendSuggestion(_ text: String) {
        inputText = text
    }
    
    func sendInputMessage() async {
        let cleanText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanText.isEmpty else { return }
        
        // Append user prompt instantly
        messages.append(ChatMessageDisplay(text: cleanText, isUser: true, recommendedProductIds: []))
        inputText = ""
        isLoading = true
        
        do {
            // Mapping UI Interaction directly to Domain Engine Client via repository wrapper
            let result: AIChatResponse = try await runShoppingAssistantUseCase.execute(
                userQuery: cleanText,
                chatHistory: [], // Map previous conversation arrays here if needed
                availableCatalog: [] // Pass catalog down from parent container or data persistence layer
            )
            
            messages.append(ChatMessageDisplay(
                text: result.replyText,
                isUser: false,
                recommendedProductIds: result.recommendedProductIds
            ))
        } catch {
            messages.append(ChatMessageDisplay(text: "Sorry, I had trouble parsing that. Please try again.", isUser: false, recommendedProductIds: []))
        }
        
        isLoading = false
    }
}
