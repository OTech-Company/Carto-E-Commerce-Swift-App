//
//  FavoritesUseCases.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

struct GetFavoritesUseCase {
    let repository: FavoritesRepository
    func execute() -> [FavoriteItem] { repository.getFavorites() }
}

struct IsFavoriteUseCase {
    let repository: FavoritesRepository
    func execute(productId: Int) -> Bool { repository.isFavorite(productId: productId) }
}

struct AddFavoriteUseCase {
    let repository: FavoritesRepository
    func execute(product: Product) { repository.addFavorite(FavoriteItem(product: product)) }
}

struct RemoveFavoriteUseCase {
    let repository: FavoritesRepository
    func execute(productId: Int) { repository.removeFavorite(productId: productId) }
}
