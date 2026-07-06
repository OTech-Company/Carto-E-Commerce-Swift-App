//
//  CartUseCase.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

protocol CartUseCaseProtocol {
    func addToCart(product: Product, color: String, size: String) -> CartItem?
    func updateQuantity(_ item: CartItem, to newQuantity: Int) -> CartItem
    func incrementQuantity(_ item: CartItem) -> CartItem
    func decrementQuantity(_ item: CartItem) -> CartItem
    func removeFromCart(_ item: CartItem)
    func selectVariant(product: Product, color: String, size: String, in items: [CartItem]) -> CartItem?
    func canIncrement(_ item: CartItem) -> Bool
    func canDecrement(_ item: CartItem) -> Bool
}

final class CartUseCase: CartUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func addToCart(product: Product, color: String, size: String) -> CartItem? {
        let stock = product.variants.first?.inventoryQuantity ?? 0
        guard stock > 0 else { return nil }

        if let existing = repository.cartItem(productId: product.id, color: color, size: size) {
            let clampedQuantity = min(existing.quantity + 1, stock)
            var updated = existing
            updated.quantity = clampedQuantity
            repository.addOrUpdate(updated)
            return updated
        }

        let newItem = CartItem(product: product, selectedColor: color, selectedSize: size, quantity: 1)
        repository.addOrUpdate(newItem)
        return newItem
    }

    func updateQuantity(_ item: CartItem, to newQuantity: Int) -> CartItem {
        let clamped = max(1, min(newQuantity, item.availableStock))
        var updated = item
        updated.quantity = clamped
        repository.addOrUpdate(updated)
        return updated
    }

    func incrementQuantity(_ item: CartItem) -> CartItem {
        guard canIncrement(item) else { return item }
        return updateQuantity(item, to: item.quantity + 1)
    }

    func decrementQuantity(_ item: CartItem) -> CartItem {
        if item.quantity == 1 {
            repository.remove(
                productId: item.productId,
                color: item.selectedColor,
                size: item.selectedSize
            )
            return item
        }

        return updateQuantity(item, to: item.quantity - 1)
    }

    func removeFromCart(_ item: CartItem) {
        repository.remove(productId: item.productId, color: item.selectedColor, size: item.selectedSize)
    }

    func selectVariant(product: Product, color: String, size: String, in items: [CartItem]) -> CartItem? {
        guard let currentItem = items.first(where: { $0.productId == product.id }) else { return nil }

        repository.remove(productId: currentItem.productId, color: currentItem.selectedColor, size: currentItem.selectedSize)

        let stock = product.variants.first?.inventoryQuantity ?? 0
        let clampedQuantity = min(currentItem.quantity, max(stock, 1))
        var moved = currentItem
        moved.selectedColor = color
        moved.selectedSize = size
        moved.quantity = clampedQuantity
        repository.addOrUpdate(moved)
        return moved
    }

    func canIncrement(_ item: CartItem) -> Bool {
        item.quantity < item.availableStock
    }

    func canDecrement(_ item: CartItem) -> Bool {
        item.quantity > 0
    }
}
