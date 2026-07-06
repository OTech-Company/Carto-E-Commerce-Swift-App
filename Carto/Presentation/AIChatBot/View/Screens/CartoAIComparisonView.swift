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
            
            // Dual Search Inputs Layer with dynamic recommendations overlay
            VStack(spacing: 10) {
                ComparisonInputField(
                    title: "First Product",
                    query: $viewModel.firstQuery,
                    selectedProduct: viewModel.selectedFirstProduct,
                    recommendations: viewModel.firstProductRecommendations,
                    onSelect: { viewModel.selectFirstProduct($0) }
                )
                
                ComparisonInputField(
                    title: "Second Product",
                    query: $viewModel.secondQuery,
                    selectedProduct: viewModel.selectedSecondProduct,
                    recommendations: viewModel.secondProductRecommendations,
                    onSelect: { viewModel.selectSecondProduct($0) }
                )
                
                if viewModel.selectedFirstProduct != nil && viewModel.selectedSecondProduct != nil {
                    Button(action: { Task { await viewModel.submitComparison() } }) {
                        HStack {
                            Image(systemName: "arrow.2.squarepath")
                            Text("Run Analysis Matrix")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(16)
            .background(Color(.systemBackground).opacity(0.8))
            
            // Dynamic Results Content Display
            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("Compiling Groq LLM metrics...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    } else if let error = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(error)
                                .font(.footnote)
                        }
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    } else if let matrix = viewModel.comparisonResult {
                        ComparisonResultDashboard(
                            matrix: matrix,
                            p1: viewModel.selectedFirstProduct,
                            p2: viewModel.selectedSecondProduct
                        )
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // Empty State Vibe Placeholder
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundColor(.blue.opacity(0.6))
                            Text("Select two items above to begin contrasting details.")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 60)
                    }
                    Spacer().frame(height: 30)
                }
                .animation(.easeInOut, value: viewModel.isLoading)
            }
            
            // Bottom contextual baseline suggestions chips
            if !viewModel.suggestionChips.isEmpty && viewModel.comparisonResult == nil && !viewModel.isLoading {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Popular Comparisons")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.suggestionChips, id: \.self) { chip in
                                Text(chip)
                                    .font(.footnote)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        viewModel.clearForm()
                                        viewModel.firstQuery = chip
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .background(AmbientBlobBackground())
    }
}

// MARK: - Subcomponent: Shared Layout Custom Input Fields
struct ComparisonInputField: View {
    let title: String
    @Binding var query: String
    let selectedProduct: Product?
    let recommendations: [Product]
    let onSelect: (Product) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(title, text: $query)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            if selectedProduct != nil {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 12)
                            }
                        }
                    )
            }
            
            // Filter Dropdown Overlay logic
            if !recommendations.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(recommendations.prefix(3)) { product in
                        Button(action: { onSelect(product) }) {
                            HStack(spacing: 12) {
                                if let urlString = product.mainImageUrl, let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 32, height: 32)
                                    .cornerRadius(6)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(product.title)
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    Text(product.vendor)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice)
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                        }
                        Divider().padding(.horizontal, 12)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
    }
}

// MARK: - Subcomponent: Comparison Table Results Dashboard Builder
struct ComparisonResultDashboard: View {
    let matrix: AIComparisonResponse
    let p1: Product?
    let p2: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary Block Callout
            VStack(alignment: .leading, spacing: 6) {
                Text("Executive Summary")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(matrix.summary)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.blue.opacity(0.05))
            .cornerRadius(12)
            
            // Spec Grid Matrix Block
            VStack(alignment: .leading, spacing: 12) {
                Text("Specifications Breakdown")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                ForEach(matrix.comparisons, id: \.metricName) { metric in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(metric.metricName)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                            GridRow {
                                Text(p1?.title ?? "Product 1")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 100, alignment: .leading)
                                Text(metric.values["\(p1?.id ?? 1)"] ?? "N/A")
                                    .font(.footnote)
                            }
                            GridRow {
                                Text(p2?.title ?? "Product 2")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(width: 100, alignment: .leading)
                                Text(metric.values["\(p2?.id ?? 2)"] ?? "N/A")
                                    .font(.footnote)
                            }
                        }
                        .padding(10)
                        .background(Color(.systemGray6).opacity(0.4))
                        .cornerRadius(8)
                    }
                }
            }
            
            // Bottom Final Verdict Placement Block
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.gray)
                    Text("AI Verdict")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                Text(matrix.verdict)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.05))
            .cornerRadius(12)
        }
    }
}
