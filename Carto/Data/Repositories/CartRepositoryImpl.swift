//
//  CartRepositoryImpl.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

final class CartRepositoryImpl: CartRepository {

    private let remote: CartRemoteDataSource
    private let store: CartStateStore
    private let cartIdKey = "storefront_cart_id"

    private var cartId: String? {
        get { UserDefaults.standard.string(forKey: cartIdKey) }
        set { UserDefaults.standard.set(newValue, forKey: cartIdKey) }
    }

    init(remote: CartRemoteDataSource, store: CartStateStore = .shared) {
        self.remote = remote
        self.store = store
    }

    func fetchCart() async throws -> CartModel? {
        guard let id = cartId else { return nil }
        let cart = try await remote.fetchCart(id: id)
        await MainActor.run { store.cart = cart }
        return cart
    }

    func addLine(variantId: String, quantity: Int) async throws -> CartModel {
        let line = StorefrontCartLineInput(merchandiseId: variantId, quantity: quantity, attributes: nil)

        let cart: CartModel
        if let existingId = cartId {
            cart = try await remote.addLines(cartId: existingId, lines: [line])
        } else {
            cart = try await remote.createCart(lines: [line])
            cartId = cart.id
        }

        await MainActor.run { store.cart = cart }
        return cart
    }

    func updateLine(lineId: String, quantity: Int) async throws -> CartModel {
        guard let id = cartId else {
            throw CartRepositoryError.noCartFound
        }
        let input = StorefrontCartLineUpdateInput(id: lineId, quantity: quantity, attributes: nil)
        let cart = try await remote.updateLines(cartId: id, lines: [input])
        await MainActor.run { store.cart = cart }
        return cart
    }

    func removeLine(lineId: String) async throws -> CartModel {
        guard let id = cartId else {
            throw CartRepositoryError.noCartFound
        }
        let cart = try await remote.removeLines(cartId: id, lineIds: [lineId])
        await MainActor.run { store.cart = cart }
        return cart
    }

    func applyDiscountCodes(_ codes: [String]) async throws -> CartModel {
        guard let id = cartId else {
            throw CartRepositoryError.noCartFound
        }
        let cart = try await remote.updateDiscountCodes(cartId: id, discountCodes: codes)
        await MainActor.run { store.cart = cart }
        return cart
    }
}

enum CartRepositoryError: LocalizedError {
    case noCartFound

    var errorDescription: String? {
        switch self {
        case .noCartFound: return "No active cart found. Please add items first."
        }
    }
}
