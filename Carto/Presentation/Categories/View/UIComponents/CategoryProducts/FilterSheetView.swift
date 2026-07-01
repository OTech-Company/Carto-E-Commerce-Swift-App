//
//  FilterSheetView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//
import SwiftUI

struct FilterSheetView: View {

    @ObservedObject var viewModel: CategoryProductsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        NavigationStack {
            ScrollView {

                VStack(alignment: .leading, spacing: 20) {
                    
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
                                            ? Color.black
                                            : Color.gray.opacity(0.15)
                                        )
                                        .foregroundStyle(
                                            viewModel.selectedProductType == type
                                            ? .white
                                            : .black
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }

                        Divider()
                    }
                    
                    if !viewModel.brands.isEmpty {
                        
                        Text("Brands")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))]) {
                            
                            ForEach(viewModel.brands, id: \.self) { brand in
                                
                                Button {
                                    
                                    if viewModel.selectedBrands.contains(brand) {
                                        viewModel.selectedBrands.remove(brand)
                                    } else {
                                        viewModel.selectedBrands.insert(brand)
                                    }
                                    
                                } label: {
                                    
                                    HStack {
                                        
                                        Image(systemName:
                                                viewModel.selectedBrands.contains(brand)
                                              ? "checkmark.square.fill"
                                              : "square")
                                        
                                        Text(brand)
                                    }
                                }
                                .foregroundStyle(.primary)
                            }
                        }
                        
                        Divider()
                    }
                    Text("Price Range")
                        .font(.headline)

                    Text("Minimum: $\(Int(viewModel.minPrice))")

                    Slider(value: $viewModel.minPrice,
                           in: 0...viewModel.maxPrice)

                    Text("Maximum: $\(Int(viewModel.maxPrice))")

                    Slider(value: $viewModel.maxPrice,
                           in: viewModel.minPrice...1000)

                    Divider()

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
                                            ? .black
                                            : Color.gray.opacity(0.15)
                                        )
                                        .foregroundStyle(
                                            viewModel.selectedSizes.contains(size)
                                            ? .white
                                            : .black
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }

                        Divider()
                    }
                    
                    if !viewModel.availableColors.isEmpty {

                        Text("Colors")
                            .font(.headline)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {

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

                                        Text(color)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(
                                        viewModel.selectedColors.contains(color)
                                        ? Color.black
                                        : Color.gray.opacity(0.15)
                                    )
                                    .foregroundStyle(
                                        viewModel.selectedColors.contains(color)
                                        ? .white
                                        : .black
                                    )
                                    .clipShape(Capsule())
                                }
                            }
                        }

                        Divider()
                    }

                    Button {

                        viewModel.applyFilters()
                        dismiss()

                    } label: {

                        Text("Apply Filters")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.black)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

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
