//
//  FavoritesViewModel.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published private(set) var favorites: [FavoriteItem] = []
    @Published var itemPendingDeletion: FavoriteItem?
    @Published var showDeleteConfirmation = false
    @Published var navigateToProduct: Product?

    private let repository: FavoritesRepository
    private var cancellable: AnyCancellable?
    private var isPerformingLocalChange = false

    init(
        repository: FavoritesRepository,
        store: FavoritesStateStore = .shared
    ) {
        self.repository = repository
        loadFavorites()

        Task { [weak self] in
            await self?.repository.syncFromRemote()
            self?.loadFavorites()
        }

        cancellable = store.$favoriteIds
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, !self.isPerformingLocalChange else { return }
                self.loadFavorites()
            }
    }

    func loadFavorites() {
        favorites = repository.getFavorites()
    }

    func requestDelete(_ item: FavoriteItem) {
        itemPendingDeletion = item
        showDeleteConfirmation = true
    }

    func confirmDelete() {
        guard let item = itemPendingDeletion else { return }
        isPerformingLocalChange = true
        repository.removeFavorite(productId: item.id)
        itemPendingDeletion = nil
        loadFavorites()
        isPerformingLocalChange = false
    }

    func cancelDelete() {
        itemPendingDeletion = nil
    }

    func didTapCard(_ item: FavoriteItem) {
        navigateToProduct = item.product
    }
}
