//
//  CartViewModel.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var cartItems: [CartItem] = []
    @Published var navigateToProduct: Product?

    private let useCase: CartUseCaseProtocol
    private let repository: CartRepository
    private var cancellable: AnyCancellable?

    init(useCase: CartUseCaseProtocol, repository: CartRepository, store: CartStateStore = .shared) {
        self.useCase = useCase
        self.repository = repository
        self.cartItems = store.allItems

        Task { [weak self] in
            await self?.repository.syncFromRemote()
        }

        cancellable = store.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cartItems = store.allItems
            }
    }

    var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var hasItems: Bool {
        !cartItems.isEmpty
    }

    var deliveryFee: Double {
        guard hasItems else { return 0 }
        return subtotal >= 500 ? 0 : 50
    }

    func increment(_ item: CartItem) {
        _ = useCase.incrementQuantity(item)
    }

    func decrement(_ item: CartItem) {
        _ = useCase.decrementQuantity(item)
    }

    func remove(_ item: CartItem) {
        useCase.removeFromCart(item)
    }

    func canIncrement(_ item: CartItem) -> Bool {
        useCase.canIncrement(item)
    }

    func canDecrement(_ item: CartItem) -> Bool {
        item.quantity > 1
    }

    func didTapItem(_ item: CartItem) {
        navigateToProduct = item.product
    }
}
