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

// MARK: - Subcomponent: Side-by-Side Visual Anchor
struct ComparisonVisualHeader: View {
    let p1: Product?
    let p2: Product?
    
    var body: some View {
        HStack(spacing: 0) {
            ProductMiniCard(product: p1)
            
            Text("VS")
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(10)
                .background(Color(.systemGroupedBackground))
                .clipShape(Circle())
                .zIndex(1)
                .padding(.horizontal, -16)
            
            ProductMiniCard(product: p2)
        }
    }
}

struct ProductMiniCard: View {
    let product: Product?
    
    var body: some View {
        HStack(spacing: 12) {
            if let urlString = product?.mainImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product?.title ?? "Product Reference")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(product?.vendor ?? "Vendor")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
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
                    .font(.subheadline)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            if selectedProduct != nil {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 14)
                            }
                        }
                    )
            }
            
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
                                    .frame(width: 36, height: 36)
                                    .cornerRadius(6)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
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
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                        }
                        Divider().padding(.horizontal, 14)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            }
        }
    }
}

// MARK: - Subcomponent: Refactored Comparison Table Dashboard
struct ComparisonResultDashboard: View {
    let matrix: AIComparisonResponse
    let p1: Product?
    let p2: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Native Structured Specs Table
            VStack(alignment: .leading, spacing: 0) {
                // Table Header
                HStack(spacing: 0) {
                    Text("Metric")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)
                    
                    Spacer()
                    
                    Text(p1?.title ?? "Product 1")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 8)
                    
                    Text(p2?.title ?? "Product 2")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))
                
                Divider()
                
                // Table Body Rows
                ForEach(matrix.comparisons, id: \.metricName) { metric in
                    HStack(spacing: 0) {
                        // Feature label column
                        Text(metric.metricName)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(width: 90, alignment: .leading)
                        
                        Spacer()
                        
                        // Product 1 Column value
                        Text(metric.values["\(p1?.id ?? 1)"] ?? "—")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 8)
                        
                        // Product 2 Column value
                        Text(metric.values["\(p2?.id ?? 2)"] ?? "—")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    Divider()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 0.5)
            )
            
            // Summary Block Callout
            VStack(alignment: .leading, spacing: 6) {
                Text("Analysis Summary")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(matrix.summary)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Bottom Final Verdict Placement Block
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("AI Verdict")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                Text(matrix.verdict)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.06))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.15), lineWidth: 1)
            )
        }
    }
}
