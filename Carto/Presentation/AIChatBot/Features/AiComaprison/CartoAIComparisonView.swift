//
//  CartoAIComparisonView.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI

// MARK: - Carto AI Structured Product Comparison Screen
struct CartoAIComparisonView: View {
    @StateObject private var viewModel: CartoAIComparisonViewModel
    
    init(compareUseCase: CompareProductsUseCase, productsUseCase: ProductUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: CartoAIComparisonViewModel(
            compareUseCase: compareUseCase,
            productsUseCase: productsUseCase
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(title: "AI Product Comparison")
            
            // Dual Search Inputs Layer
            VStack(spacing: 12) {
                ComparisonInputField(
                    title: "First Product...",
                    query: $viewModel.firstQuery,
                    selectedProduct: viewModel.selectedFirstProduct,
                    recommendations: viewModel.firstProductRecommendations,
                    onSelect: { viewModel.selectFirstProduct($0) }
                )
                
                ComparisonInputField(
                    title: "Second Product...",
                    query: $viewModel.secondQuery,
                    selectedProduct: viewModel.selectedSecondProduct,
                    recommendations: viewModel.secondProductRecommendations,
                    onSelect: { viewModel.selectSecondProduct($0) }
                )
                
                if viewModel.selectedFirstProduct != nil && viewModel.selectedSecondProduct != nil {
                    Button(action: { Task { await viewModel.submitComparison() } }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.2.squarepath")
                            Text("Run Analysis Matrix")
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            
            Divider()
            
            // Dynamic Results Content Display
            GeometryReader { geo in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        if viewModel.isLoading {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .tint(.primary)
                                Text("Analyzing parameters with Groq AI...")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geo.size.height * 0.7)
                        } else if let error = viewModel.errorMessage {
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(.footnote)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.red.opacity(0.05))
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        } else if let matrix = viewModel.comparisonResult {
                            // Header slot showing items being compared side-by-side
                            ComparisonVisualHeader(
                                p1: viewModel.selectedFirstProduct,
                                p2: viewModel.selectedSecondProduct
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            
                            ComparisonResultDashboard(
                                matrix: matrix,
                                p1: viewModel.selectedFirstProduct,
                                p2: viewModel.selectedSecondProduct
                            )
                            .padding(.horizontal, 16)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            // Premium Redesigned Initial Placeholder State matching white canvas layout
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(Color.accentColor.opacity(0.04))
                                        .frame(width: 80, height: 80)
                                        .blur(radius: 4)
                                    
                                    Image(systemName: "sparkles.rectangle.stack")
                                        .font(.system(size: 30, weight: .light))
                                        .foregroundColor(.accentColor.opacity(0.6))
                                }
                                
                                VStack(spacing: 8) {
                                    Text("Ready for Side-by-Side Analysis")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text("Select two items above to let AI contrast specifications, pricing strategies, and user reviews.")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                }
                                .padding(.horizontal, 32)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: geo.size.height * 0.65)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                        Spacer().frame(height: 40)
                    }
                }
            }
            .background(Color(.systemBackground).ignoresSafeArea()) // 🌟 Changes workspace color away from system gray backdrops
            .animation(.smooth(duration: 0.35, extraBounce: 0), value: viewModel.isLoading)
        }
    }
}
