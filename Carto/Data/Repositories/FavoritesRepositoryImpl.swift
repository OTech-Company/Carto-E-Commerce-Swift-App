//
//  FavoritesRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let local: FavoritesLocalDataSourceProtocol
    private let store: FavoritesStateStore

    init(local: FavoritesLocalDataSourceProtocol, store: FavoritesStateStore = .shared) {
        self.local = local
        self.store = store
        store.setInitial(Set(local.fetchAll().map { $0.id }))
    }

    func getFavorites() -> [FavoriteItem] { local.fetchAll() }

    func isFavorite(productId: Int) -> Bool {
        store.isFavorite(productId)
    }

    func addFavorite(_ item: FavoriteItem) {
        local.save(item)
        store.markFavorite(item.id)
    }

    func removeFavorite(productId: Int) {
        local.delete(productId: productId)
        store.unmarkFavorite(productId)
    }
}
