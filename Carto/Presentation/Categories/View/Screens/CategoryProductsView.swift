//
//  CategoryProductsView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//


import SwiftUI

struct CategoryProductsView: View {

    @StateObject private var viewModel: CategoryProductsViewModel

    let categoryId: String

    init(categoryId: String,
         viewModel: CategoryProductsViewModel) {

        self.categoryId = categoryId
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {

        NavigationStack {

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

                                ProductCardView(product: product)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Products")
            .sheet(isPresented: $viewModel.showFilters) {

                FilterSheetView()
            }
            .task {

                await viewModel.loadProducts(categoryId: categoryId)
            }
        }
    }
}