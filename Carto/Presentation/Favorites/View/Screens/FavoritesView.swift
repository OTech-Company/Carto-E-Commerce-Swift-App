//
//  FavoritesView.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct FavoritesView: View {

    @StateObject var viewModel: FavoritesViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Favorites")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top)

                if viewModel.favorites.isEmpty {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()

                            Image("empty_favorites")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.65)
                                .offset(y: -30)

                            Spacer()
                        }
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                    }
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(.container, edges: .horizontal)
                }else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favorites) { item in
                                ProductCard(product: item.product, onFavoriteTap: {
                                    viewModel.requestDelete(item)
                                })
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.didTapCard(item)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.loadFavorites()
            }
            .alert("Remove from favorites?", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {
                    viewModel.cancelDelete()
                }
                Button("Delete", role: .destructive) {
                    viewModel.confirmDelete()
                }
            } message: {
                Text("This item will be removed from your favorites.")
            }
            .navigationDestination(
                isPresented: Binding(
                    get: { viewModel.navigateToProduct != nil },
                    set: { if !$0 { viewModel.navigateToProduct = nil } }
                )
            ) {
                if let product = viewModel.navigateToProduct {
                    ProductsInfoView(
                        viewModel: DIContainer.shared.makeProductsInfoViewModel(product: product)
                    )
                }
            }
        }
    }
}
