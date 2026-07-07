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
    @Published var discount: Double = 0

    private let useCase: CartUseCaseProtocol
    private let repository: CartRepository
    private var cancellables = Set<AnyCancellable>()

    init(useCase: CartUseCaseProtocol, repository: CartRepository, store: CartStateStore = .shared) {
        self.useCase = useCase
        self.repository = repository
        self.cartItems = store.allItems

        Task { [weak self] in
            await self?.repository.syncFromRemote()
        }

        store.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.cartItems = store.allItems
                self?.recalculateDiscount()
            }
            .store(in: &cancellables)
            
        store.$isCouponApplied
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.recalculateDiscount()
            }
            .store(in: &cancellables)
    }

    private func recalculateDiscount() {
        discount = CartStateStore.shared.discountAmount
    }

    var subtotal: Double {
        CartStateStore.shared.subtotal
    }

    var hasItems: Bool {
        !cartItems.isEmpty
    }

    var deliveryFee: Double {
        CartStateStore.shared.deliveryFee
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
