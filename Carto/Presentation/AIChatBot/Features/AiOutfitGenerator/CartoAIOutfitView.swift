//
//  CartoAIOutfitView.swift
//  Carto
//
//  Created by Ossama Abdellatif on 06/07/2026.
//
import SwiftUI

struct CartoAIOutfitView: View {
    @StateObject private var viewModel: CartAiOutfitViewModel
    
    init(runOutfitSuggestionsUseCase: GenerateOutfitSuggestionsUseCase, productsUseCase: ProductUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: CartAiOutfitViewModel(
            runOutfitSuggestionsUseCase: runOutfitSuggestionsUseCase,
            productsUseCase: productsUseCase
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(title: "AI Outfit Stylist")
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 10)
                        
                        if viewModel.outfitResult == nil && !viewModel.isLoading {
                            VStack(spacing: 16) {
                                Image(systemName: "sparkles.rectangle.stack")
                                    .font(.system(size: 32, weight: .light))
                                    .foregroundColor(.accentColor.opacity(0.6))
                                Text("What are we dressing up for?")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 120)
                        }
                        
                        if let outfit = viewModel.outfitResult {
                            // User Prompt Message Bubble
                            HStack {
                                Spacer()
                                Text(viewModel.inputText)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .foregroundColor(.primary)
                                    .cornerRadius(18)
                            }
                            .padding(.horizontal, 16)
                            
                            // AI Text Response Bubble with Sparkle Icon Prefix
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.8))
                                    .clipShape(Circle())
                                
                                Text(outfit.stylingReasoning)
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.blue.opacity(0.12))
                                    .foregroundColor(.primary)
                                    .cornerRadius(18)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            
                            // Master Outfit Set Card Panel matching Screenshot 2026-07-06 at 8.05.38 PM.png
                            VStack(alignment: .leading, spacing: 16) {
                                Text(outfit.outfitTitle) // E.g., "Outfit Set"
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 4)
                                
                                // 2-Column Grid Layout for Products
                                let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.recommendedProducts) { product in
                                        OutfitGridItemCard(product: product, onSelect: {
                                            print("Navigate to Product Details for: \(product.id)")
                                        })
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                            .padding(.horizontal, 16)
                            .id("outfitResultBlock")
                        }
                        
                        if viewModel.isLoading {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .tint(.secondary)
                                Text("Curating your custom look...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .id("loadingIndicatorBlock")
                        }
                    }
                }
                .onChange(of: viewModel.isLoading) { isLoading in
                    if isLoading {
                        withAnimation { proxy.scrollTo("loadingIndicatorBlock", anchor: .bottom) }
                    }
                }
                .onChange(of: viewModel.outfitResult?.outfitTitle) { _ in
                    withAnimation(.smooth) { proxy.scrollTo("outfitResultBlock", anchor: .top) }
                }
            }
            
            // Context Selection Chips Dynamic Strip
            if !viewModel.suggestionChips.isEmpty && viewModel.outfitResult == nil && !viewModel.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.suggestionChips, id: \.self) { chip in
                            Button(action: { viewModel.selectSuggestionChip(chip) }) {
                                Text(chip)
                                    .font(.footnote)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6).opacity(0.8))
                                    .foregroundColor(.primary)
                                    .cornerRadius(18)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 10)
            }
            
            ChatInputBar(text: $viewModel.inputText) {
                Task { await viewModel.generateOutfitMatrix() }
            }
            .padding(.bottom, 12)
        }
        .background(Color(.systemGray6).opacity(0.3).ignoresSafeArea())
    }
}
