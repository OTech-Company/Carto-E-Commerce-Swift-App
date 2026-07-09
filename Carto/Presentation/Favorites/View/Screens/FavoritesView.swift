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
                Text("favorites_title")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top)

                if viewModel.favorites.isEmpty {
                    ZStack {
                        Image("empty_favorites")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.horizontal, 40)
                            .padding(.top, 80)
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            
                            Text("no_favorites_yet")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.top, 10)
                            
                            Text("no_fav_found_desc")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                            
                            Spacer()
                                .frame(height: 80)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
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
                Button("cancel_btn", role: .cancel) {
                    viewModel.cancelDelete()
                }
                Button("delete_btn", role: .destructive) {
                    viewModel.confirmDelete()
                }
            } message: {
                Text("remove_favorite_desc")
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
