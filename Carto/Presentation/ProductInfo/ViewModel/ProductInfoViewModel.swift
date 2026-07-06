//
//  ProductsInfoViewModel.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation
import Combine

@MainActor
final class ProductsInfoViewModel: ObservableObject {
    let product: Product
    @Published var selectedSize: String
    @Published var selectedColorIndex: Int
    @Published var quantity: Int
    @Published private(set) var isFavorite: Bool
    @Published private(set) var isOutOfStock: Bool

    private let favoritesRepository: FavoritesRepository
    private let cartUseCase: CartUseCaseProtocol
    private let cartStore: CartStateStore
    private var cancellables: Set<AnyCancellable> = []
    private var isApplyingRemoteChange = false

    private var selectedColor: String {
        guard product.colors.indices.contains(selectedColorIndex) else { return product.colors.first ?? "" }
        return product.colors[selectedColorIndex]
    }

    init(
        product: Product,
        favoritesRepository: FavoritesRepository,
        cartUseCase: CartUseCaseProtocol,
        favoritesStore: FavoritesStateStore = .shared,
        cartStore: CartStateStore = .shared
    ) {
        self.product = product
        self.favoritesRepository = favoritesRepository
        self.cartUseCase = cartUseCase
        self.cartStore = cartStore
        self.isFavorite = favoritesStore.isFavorite(product.id)

        let variant = cartStore.selectedVariant(
            for: product.id,
            fallbackColor: product.colors.first ?? "",
            fallbackSize: product.sizes.first ?? ""
        )
        self.selectedSize = variant.size
        self.selectedColorIndex = product.colors.firstIndex(of: variant.color) ?? 0

        let existing = cartStore.item(productId: product.id, color: variant.color, size: variant.size)
        self.quantity = existing?.quantity ?? 0
        self.isOutOfStock = (product.variants.first?.inventoryQuantity ?? 0) <= 0

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
                guard let self, !self.isApplyingRemoteChange else { return }
                let currentItem = cartStore.item(productId: self.product.id, color: self.selectedColor, size: self.selectedSize)
                self.isApplyingRemoteChange = true
                self.quantity = currentItem?.quantity ?? 0
                self.isApplyingRemoteChange = false
            }
            .store(in: &cancellables)

        cartStore.$selectedVariants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] variants in
                guard let self, !self.isApplyingRemoteChange else { return }
                guard let variant = variants[self.product.id] else { return }
                guard variant.color != self.selectedColor || variant.size != self.selectedSize else { return }
                self.isApplyingRemoteChange = true
                self.selectedSize = variant.size
                self.selectedColorIndex = self.product.colors.firstIndex(of: variant.color) ?? self.selectedColorIndex
                self.isApplyingRemoteChange = false
            }
            .store(in: &cancellables)

        $selectedSize
            .dropFirst()
            .sink { [weak self] newSize in
                guard let self, !self.isApplyingRemoteChange else { return }
                self.applyVariantChange(color: self.selectedColor, size: newSize)
            }
            .store(in: &cancellables)

        $selectedColorIndex
            .dropFirst()
            .sink { [weak self] newIndex in
                guard let self, !self.isApplyingRemoteChange else { return }
                guard self.product.colors.indices.contains(newIndex) else { return }
                self.applyVariantChange(color: self.product.colors[newIndex], size: self.selectedSize)
            }
            .store(in: &cancellables)
    }

    func quantityChanged(to newValue: Int) {
        guard !isApplyingRemoteChange else { return }

        if newValue <= 0 {
            if let item = cartStore.item(productId: product.id, color: selectedColor, size: selectedSize) {
                cartUseCase.removeFromCart(item)
            }
            return
        }

        guard !isOutOfStock else {
            isApplyingRemoteChange = true
            quantity = 0
            isApplyingRemoteChange = false
            return
        }

        if let existing = cartStore.item(productId: product.id, color: selectedColor, size: selectedSize) {
            if newValue > existing.quantity {
                _ = cartUseCase.incrementQuantity(existing)
            } else if newValue < existing.quantity {
                _ = cartUseCase.decrementQuantity(existing)
            }
        } else {
            _ = cartUseCase.addToCart(product: product, color: selectedColor, size: selectedSize)
        }
    }

    private func applyVariantChange(color: String, size: String) {
        let items = cartStore.items(for: product.id)
        if let moved = cartUseCase.selectVariant(product: product, color: color, size: size, in: items) {
            isApplyingRemoteChange = true
            quantity = moved.quantity
            isApplyingRemoteChange = false
        }
        cartStore.setSelectedVariant(productId: product.id, color: color, size: size)
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesRepository.removeFavorite(productId: product.id)
        } else {
            favoritesRepository.addFavorite(FavoriteItem(product: product))
        }
    }
}
