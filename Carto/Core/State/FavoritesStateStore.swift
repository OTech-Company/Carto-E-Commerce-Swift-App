//
//  FavoritesStateStore.swift
//  Carto
//
//  Created by Manona on 04/07/2026.
//

import Combine
import Foundation

final class FavoritesStateStore: ObservableObject {
    static let shared = FavoritesStateStore()

    @Published private(set) var favoriteIds: Set<Int> = []

    private init() {}

    func setInitial(_ ids: Set<Int>) {
        favoriteIds = ids
    }

    func markFavorite(_ id: Int) {
        favoriteIds.insert(id)
    }

    func unmarkFavorite(_ id: Int) {
        favoriteIds.remove(id)
    }

    func isFavorite(_ id: Int) -> Bool {
        favoriteIds.contains(id)
    }
}
