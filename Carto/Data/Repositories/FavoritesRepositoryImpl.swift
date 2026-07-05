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
    }

    func bootstrapStore() {
        store.initializeFavorites(Set(local.fetchAll().map { $0.id }))
    }

    func getFavorites() -> [FavoriteItem] { local.fetchAll() }
    func isFavorite(productId: Int) -> Bool { store.isFavorite(productId) }

    func addFavorite(_ item: FavoriteItem) {
        local.save(item)
        store.markFavorite(item.id)

        guard let uid = currentUserId() else { return }

        Task {
            do {
                try await remote.save(item, uid: uid)
            } catch {
                print("Firestore save failed for item \(item.id): \(error)")
                local.delete(productId: item.id)
                store.unmarkFavorite(item.id)
            }
        }
    }

    func removeFavorite(productId: Int) {
        let removedItem = local.fetchAll().first(where: { $0.id == productId })

        local.delete(productId: productId)
        store.unmarkFavorite(productId)

        guard let uid = currentUserId() else { return }

        Task {
            do {
                try await remote.delete(productId: productId, uid: uid)
            } catch {
                print("Firestore delete failed for item \(productId): \(error)")
                if let removedItem {
                    local.save(removedItem)
                    store.markFavorite(productId)
                }
            }
        }
    }

    func syncFromRemote() async {
        guard let uid = currentUserId() else { return }
        guard let remoteItems = try? await remote.fetchAll(uid: uid) else { return }

        let remoteIds = Set(remoteItems.map { $0.id })
        let localIds = Set(local.fetchAll().map { $0.id })

        for item in remoteItems where !localIds.contains(item.id) {
            local.save(item)
        }

        for id in localIds.subtracting(remoteIds) {
            local.delete(productId: id)
        }

        store.initializeFavorites(Set(local.fetchAll().map { $0.id }))
    }
}
