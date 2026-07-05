//
//  CartoAIChatView.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import SwiftUI


// MARK: - Carto AI Dynamic Chat Screen
struct CartoAIChatView: View {
    @StateObject private var viewModel: CartoAIChatViewModel
    
    init(runShoppingAssistantUseCase: RunShoppingAssistantUseCase) {
        _viewModel = StateObject(wrappedValue: CartoAIChatViewModel(runShoppingAssistantUseCase: runShoppingAssistantUseCase))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView()
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer().frame(height: 20)
                        
                        ForEach(viewModel.messages) { message in
                            VStack(alignment: .leading, spacing: 8) {
                                ChatBubbleView(text: message.text, isUser: message.isUser)
                                
                                // Dynamic inline product deck matching the response list if available
                                if !message.recommendedProductIds.isEmpty {
                                    ProductRecommendationRow(productIds: message.recommendedProductIds)
                                }
                            }
                            .id(message.id)
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                Text("Thinking...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        
                        SuggestionChipsView(suggestions: viewModel.suggestionChips) { selectedChip in
                            viewModel.appendSuggestion(selectedChip)
                        }
                        .padding(.top, 10)
                    }
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastElement = viewModel.messages.last {
                        withAnimation { proxy.scrollTo(lastElement.id, anchor: .bottom) }
                    }
                }
            }
            
            ChatInputBar(text: $viewModel.inputText) {
                Task { await viewModel.sendInputMessage() }
            }
            .padding(.bottom, 12)
        }
        .background(AmbientBlobBackground())
    }
}

// MARK: - Recommended Product ID Sub-Row
struct ProductRecommendationRow: View {
    let productIds: [Int]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(productIds, id: \.self) { id in
                    HStack {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.blue)
                        Text("Product #\(id)")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
