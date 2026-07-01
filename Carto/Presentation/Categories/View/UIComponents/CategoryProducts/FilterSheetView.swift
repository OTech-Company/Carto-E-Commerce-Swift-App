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

                    Text("Price Range")
                        .font(.headline)

                    Text("Minimum: $\(Int(viewModel.minPrice))")

                    Slider(value: $viewModel.minPrice,
                           in: 0...viewModel.maxPrice)

                    Text("Maximum: $\(Int(viewModel.maxPrice))")

                    Slider(value: $viewModel.maxPrice,
                           in: viewModel.minPrice...1000)

                    Divider()

                    Text("Sizes")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {

                        ForEach(viewModel.sizes, id: \.self) { size in

                            Button(size) {

                                if viewModel.selectedSizes.contains(size) {
                                    viewModel.selectedSizes.remove(size)
                                } else {
                                    viewModel.selectedSizes.insert(size)
                                }

                            }
                            .padding(.horizontal,12)
                            .padding(.vertical,8)
                            .background(
                                viewModel.selectedSizes.contains(size)
                                ? Color.black
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

                    Divider()

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
