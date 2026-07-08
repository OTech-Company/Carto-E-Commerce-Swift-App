//
//  FilterSheetView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//

import SwiftUI

struct FilterSheetView: View {

    @ObservedObject var viewModel: ProductsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Product Type Selection
                        if !viewModel.productTypes.isEmpty {
                            Text("Product Type")
                                .font(.headline)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                                ForEach(viewModel.productTypes, id: \.self) { type in
                                    Button {
                                        if viewModel.selectedProductType == type {
                                            viewModel.selectedProductType = nil
                                        } else {
                                            viewModel.selectedProductType = type
                                        }
                                        viewModel.updateAvailableFilters()
                                    } label: {
                                        Text(type)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                viewModel.selectedProductType == type
                                                ? Color.primary
                                                : Color.gray.opacity(0.15)
                                            )
                                            .foregroundStyle(
                                                viewModel.selectedProductType == type
                                                ? AnyShapeStyle(Color(.systemBackground))
                                                : AnyShapeStyle(Color.primary)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            Divider()
                        }
                        
                        // MARK: - Brands Selection
                        if !viewModel.brands.isEmpty {
                            Text("Brands")
                                .font(.headline)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))]) {
                                ForEach(viewModel.brands, id: \.self) { brand in
                                    Button {
                                        if viewModel.selectedBrands.contains(brand) {
                                            viewModel.selectedBrands.remove(brand)
                                        } else {
                                            viewModel.selectedBrands.insert(brand)
                                        }
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: viewModel.selectedBrands.contains(brand) ? "checkmark.square.fill" : "square")
                                            Text(brand)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 4)
                                    }
                                    .foregroundStyle(.primary)
                                }
                            }
                            Divider()
                        }
                        
                        // MARK: - Price Range Selection
                        Text("Price Range")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Minimum: $\(Int(viewModel.minPrice))")
                            Slider(value: $viewModel.minPrice, in: 0...1000) // Fixed standard range limits to prevent crashing

                            Text("Maximum: $\(Int(viewModel.maxPrice))")
                            Slider(value: $viewModel.maxPrice, in: 0...1000) // Fixed standard range limits to prevent crashing
                        }
                        Divider()

                        // MARK: - Sizes Selection
                        if !viewModel.availableSizes.isEmpty {
                            Text("Sizes")
                                .font(.headline)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
                                ForEach(viewModel.availableSizes, id: \.self) { size in
                                    Button {
                                        if viewModel.selectedSizes.contains(size) {
                                            viewModel.selectedSizes.remove(size)
                                        } else {
                                            viewModel.selectedSizes.insert(size)
                                        }
                                    } label: {
                                        Text(size)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                viewModel.selectedSizes.contains(size)
                                                ? Color.primary
                                                : Color.gray.opacity(0.15)
                                            )
                                            .foregroundStyle(
                                                viewModel.selectedSizes.contains(size)
                                                ? AnyShapeStyle(Color(.systemBackground))
                                                : AnyShapeStyle(Color.primary)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            Divider()
                        }
                        
                        // MARK: - Colors Selection
                        if !viewModel.availableColors.isEmpty {
                            Text("Colors")
                                .font(.headline)

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))]) {
                                ForEach(viewModel.availableColors, id: \.self) { color in
                                    Button {
                                        if viewModel.selectedColors.contains(color) {
                                            viewModel.selectedColors.remove(color)
                                        } else {
                                            viewModel.selectedColors.insert(color)
                                        }
                                    } label: {
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(color.swiftUIColor)
                                                .frame(width: 18, height: 18)
                                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 0.5))

                                            Text(color)
                                                .font(.caption)
                                        }
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .background(
                                            viewModel.selectedColors.contains(color)
                                            ? Color.primary
                                            : Color.gray.opacity(0.15)
                                        )
                                        .foregroundStyle(
                                            viewModel.selectedColors.contains(color)
                                            ? AnyShapeStyle(Color(.systemBackground))
                                            : AnyShapeStyle(Color.primary)
                                        )
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                // MARK: - Bottom Action Bar
                VStack(spacing: 0) {
                    Divider()
                    Button {
                        viewModel.applyFilters() // Executes filtering on view model
                        dismiss() // Safely closes the modal container sheet
                    } label: {
                        Text("Apply Filters")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.primary)
                            .foregroundStyle(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear All") {
                        // Ensure this method is defined in ProductsViewModel to clear all active selections
                        viewModel.clearFilters()
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}

// MARK: - Color Extension Mapping
extension String {
    var swiftUIColor: Color {
        switch lowercased() {
        case "black": return .black
        case "white": return .white
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "yellow": return .yellow
        case "gray", "grey": return .gray
        case "brown": return .brown
        case "pink": return .pink
        case "purple": return .purple
        case "orange": return .orange
        default: return .gray
        }
    }
}
