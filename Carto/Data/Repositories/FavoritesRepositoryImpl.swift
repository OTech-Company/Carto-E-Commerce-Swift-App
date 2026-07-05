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
    private let defaults: UserDefaults
    private let lastSyncedUserIdKey = "favorites_last_synced_uid"

    private var lastSyncedUserId: String? {
        get { defaults.string(forKey: lastSyncedUserIdKey) }
        set { defaults.set(newValue, forKey: lastSyncedUserIdKey) }
    }

    init(
        local: FavoritesLocalDataSourceProtocol,
        remote: FavoritesRemoteDataSourceProtocol,
        store: FavoritesStateStore = .shared,
        defaults: UserDefaults = .standard,
        currentUserId: @escaping () -> String?
    ) {
        self.local = local
        self.remote = remote
        self.store = store
        self.defaults = defaults
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
        let uid = currentUserId()

        guard uid != lastSyncedUserId else { return }

        await local.deleteAll()
        store.initializeFavorites([])

        guard let uid else {
            lastSyncedUserId = nil
            return
        }

        guard let remoteItems = try? await remote.fetchAll(uid: uid) else {
            lastSyncedUserId = uid
            return
        }

        await local.saveAll(remoteItems)
        store.initializeFavorites(Set(remoteItems.map { $0.id }))
        lastSyncedUserId = uid
    }

    func forceRefreshFromRemote() async {
        guard let uid = currentUserId() else { return }
        guard let remoteItems = try? await remote.fetchAll(uid: uid) else { return }

        let remoteIds = Set(remoteItems.map { $0.id })
        let localIds = Set(local.fetchAll().map { $0.id })
        let staleIds = Array(localIds.subtracting(remoteIds))

        await local.saveAll(remoteItems)
        await local.delete(productIds: staleIds)

        store.initializeFavorites(Set(local.fetchAll().map { $0.id }))
        lastSyncedUserId = uid
    }
}
