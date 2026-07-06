//
//  CartRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

final class CartRepositoryImpl: CartRepository {
    private let local: CartLocalDataSourceProtocol
    private let remote: CartFirestoreRemoteDataSourceProtocol
    private let store: CartStateStore
    private let currentUserId: () -> String?
    private let defaults: UserDefaults
    private let lastSyncedUserIdKey = "cart_last_synced_uid"

    private var lastSyncedUserId: String? {
        get { defaults.string(forKey: lastSyncedUserIdKey) }
        set { defaults.set(newValue, forKey: lastSyncedUserIdKey) }
    }

    init(
        local: CartLocalDataSourceProtocol,
        remote: CartFirestoreRemoteDataSourceProtocol,
        store: CartStateStore = .shared,
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
        store.initializeCart(local.fetchAll())
    }

    func getCartItems() -> [CartItem] {
        local.fetchAll()
    }

    func cartItem(productId: Int, color: String, size: String) -> CartItem? {
        store.item(productId: productId, color: color, size: size)
    }

    func addOrUpdate(_ item: CartItem) {
        local.save(item)
        store.upsert(item)

        guard let uid = currentUserId() else { return }

        Task {
            do {
                try await remote.save(item, uid: uid)
            } catch {
                print("Firestore save failed for cart item \(item.id): \(error)")
            }
        }
    }

    func remove(productId: Int, color: String, size: String) {
        let id = CartItem.makeId(productId: productId, color: color, size: size)
        local.delete(id: id)
        store.remove(id: id)

        guard let uid = currentUserId() else { return }

        Task {
            do {
                try await remote.delete(id: id, uid: uid)
            } catch {
                print("Firestore delete failed for cart item \(id): \(error)")
            }
        }
    }

    func syncFromRemote() async {
        let uid = currentUserId()

        guard uid != lastSyncedUserId else { return }

        await local.deleteAll()
        store.initializeCart([])

        guard let uid else {
            lastSyncedUserId = nil
            return
        }

        guard let remoteItems = try? await remote.fetchAll(uid: uid) else {
            lastSyncedUserId = uid
            return
        }

        await local.saveAll(remoteItems)
        store.initializeCart(remoteItems)
        lastSyncedUserId = uid
    }
}
