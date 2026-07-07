//
//  ProductCardViewModel.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import Foundation
import Combine

@MainActor
final class ProductCardViewModel: ObservableObject {
    @Published private(set) var isFavorite: Bool
    @Published private(set) var cartQuantity: Int
    @Published private(set) var isOutOfStock: Bool

    private let repository: FavoritesRepository
    private let cartUseCase: CartUseCaseProtocol
    private let cartStore: CartStateStore
    private let product: Product
    private var cancellables: Set<AnyCancellable> = []

    init(
        product: Product,
        repository: FavoritesRepository,
        cartUseCase: CartUseCaseProtocol,
        favoritesStore: FavoritesStateStore = .shared,
        cartStore: CartStateStore = .shared
    ) {
        self.product = product
        self.repository = repository
        self.cartUseCase = cartUseCase
        self.cartStore = cartStore
        self.isFavorite = favoritesStore.isFavorite(product.id)

        let variant = cartStore.selectedVariant(for: product.id, fallbackColor: product.colors.first ?? "", fallbackSize: product.sizes.first ?? "")
        self.cartQuantity = cartStore.item(productId: product.id, color: variant.color, size: variant.size)?.quantity ?? 0
        self.isOutOfStock = (product.variantFor(color: variant.color, size: variant.size)?.inventoryQuantity ?? 0) <= 0

        favoritesStore.$favoriteIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                guard let self else { return }
                self.isFavorite = ids.contains(self.product.id)
            }
            .store(in: &cancellables)

        cartStore.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let variant = cartStore.selectedVariant(for: self.product.id, fallbackColor: self.product.colors.first ?? "", fallbackSize: self.product.sizes.first ?? "")
                self.cartQuantity = cartStore.item(productId: self.product.id, color: variant.color, size: variant.size)?.quantity ?? 0
            }
            .store(in: &cancellables)
    }

    func toggleFavorite(for product: Product) {
        if isFavorite {
            repository.removeFavorite(productId: product.id)
        } else {
            repository.addFavorite(FavoriteItem(product: product))
        }
    }

    func addToCart() {
        let variant = cartStore.selectedVariant(for: product.id, fallbackColor: product.colors.first ?? "", fallbackSize: product.sizes.first ?? "")
        _ = cartUseCase.addToCart(product: product, color: variant.color, size: variant.size)
    }

    func incrementQuantity() {
        let variant = cartStore.selectedVariant(for: product.id, fallbackColor: product.colors.first ?? "", fallbackSize: product.sizes.first ?? "")
        guard let item = cartStore.item(productId: product.id, color: variant.color, size: variant.size) else { return }
        _ = cartUseCase.incrementQuantity(item)
    }

    func decrementQuantity() {
        let variant = cartStore.selectedVariant(
            for: product.id,
            fallbackColor: product.colors.first ?? "",
            fallbackSize: product.sizes.first ?? ""
        )

        guard let item = cartStore.item(
            productId: product.id,
            color: variant.color,
            size: variant.size
        ) else { return }

        if item.quantity == 1 {
            cartUseCase.removeFromCart(item)
        } else {
            _ = cartUseCase.decrementQuantity(item)
        }
    }
}
