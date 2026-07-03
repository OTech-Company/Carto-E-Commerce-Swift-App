//
//  FavoritesViewModel.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var favorites: [FavoriteItem] = []
    @Published var itemPendingDeletion: FavoriteItem?
    @Published var showDeleteConfirmation = false
    @Published var showNoInternetAlert = false
    @Published var navigateToProduct: Product?

    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let networkMonitor: NetworkMonitor

    init(
        getFavoritesUseCase: GetFavoritesUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase,
        networkMonitor: NetworkMonitor = .shared
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.networkMonitor = networkMonitor
        loadFavorites()
    }

    func loadFavorites() {
        favorites = getFavoritesUseCase.execute()
    }

    func requestDelete(_ item: FavoriteItem) {
        itemPendingDeletion = item
        showDeleteConfirmation = true
    }

    func confirmDelete() {
        guard let item = itemPendingDeletion else { return }
        removeFavoriteUseCase.execute(productId: item.id)
        itemPendingDeletion = nil
        loadFavorites()
    }

    func cancelDelete() {
        itemPendingDeletion = nil
    }

    func didTapCard(_ item: FavoriteItem) {
        guard networkMonitor.isConnected else {
            showNoInternetAlert = true
            return
        }
        navigateToProduct = Product(favorite: item)
    }
}
