//
//  CategoryProductsView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//


import SwiftUI

@available(iOS 17.0, *)
struct ProductsView: View {

    @StateObject private var viewModel: ProductsViewModel
    @Environment(Router<AppRoute>.self) private var router

    let categoryId: String?
    let brandID: Int?

    init(categoryId: String? = nil, brandID: Int? = nil, viewModel: ProductsViewModel) {
        self.categoryId = categoryId
        self.brandID = brandID
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        VStack {

            HStack {

                TextField("Search products...",
                          text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.search()
                }

                Button {

                    viewModel.showFilters.toggle()

                } label: {

                    Image(systemName: "slider.horizontal.3")
                }

            }
            .padding()

            if viewModel.isLoading {

                Spacer()

                ProgressView()

                Spacer()

            } else {

                ScrollView {

                    LazyVGrid(columns: columns,
                              spacing: 16) {

                        ForEach(viewModel.filteredProducts) { product in
                            Button {
                                router.push(to: .productDetails(product: product))
                            } label: {
                                ProductCard(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Products")
        .sheet(isPresented: $viewModel.showFilters) {

            FilterSheetView(viewModel: viewModel)
        }
        .task {
            if let brandID = brandID {
                await viewModel.loadProducts(brandId: brandID)
            } else if let categoryId = categoryId {
                await viewModel.loadProducts(categoryId: categoryId)
            }
        }
    }
}
