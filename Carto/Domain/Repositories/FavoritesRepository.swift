//
//  FavoritesRepository.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

protocol FavoritesRepository {
    func getFavorites() -> [FavoriteItem]
    func isFavorite(productId: Int) -> Bool
    func addFavorite(_ item: FavoriteItem)
    func removeFavorite(productId: Int)
    func syncFromRemote() async
}
