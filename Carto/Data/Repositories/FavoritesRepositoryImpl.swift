//
//  FavoritesRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let local: FavoritesLocalDataSourceProtocol

    init(local: FavoritesLocalDataSourceProtocol) {
        self.local = local
    }

    func getFavorites() -> [FavoriteItem] { local.fetchAll() }
    func isFavorite(productId: Int) -> Bool { local.isFavorite(productId: productId) }
    func addFavorite(_ item: FavoriteItem) { local.save(item) }
    func removeFavorite(productId: Int) { local.delete(productId: productId) }
}
