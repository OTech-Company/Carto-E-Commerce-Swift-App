//
//  FavoritesRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let local: FavoritesLocalDataSourceProtocol
    private let remote: FavoritesRemoteDataSourceProtocol
    private let store: FavoritesStateStore
    private let currentUserId: () -> String?

    init(
        local: FavoritesLocalDataSourceProtocol,
        remote: FavoritesRemoteDataSourceProtocol,
        store: FavoritesStateStore = .shared,
        currentUserId: @escaping () -> String?
    ) {
        self.local = local
        self.remote = remote
        self.store = store
        self.currentUserId = currentUserId
        store.setInitial(Set(local.fetchAll().map { $0.id }))
    }

    func getFavorites() -> [FavoriteItem] { local.fetchAll() }
    func isFavorite(productId: Int) -> Bool { store.isFavorite(productId) }

    func addFavorite(_ item: FavoriteItem) {
        local.save(item)
        store.markFavorite(item.id)
        guard let uid = currentUserId() else { return }
        Task { try? await remote.save(item, uid: uid) }
    }

    func removeFavorite(productId: Int) {
        local.delete(productId: productId)
        store.unmarkFavorite(productId)
        guard let uid = currentUserId() else { return }
        Task { try? await remote.delete(productId: productId, uid: uid) }
    }

    func syncFromRemote() async {
        guard let uid = currentUserId() else { return }
        guard let remoteItems = try? await remote.fetchAll(uid: uid) else { return }
        for item in remoteItems where !local.isFavorite(productId: item.id) {
            local.save(item)
        }
        store.setInitial(Set(local.fetchAll().map { $0.id }))
    }
}
