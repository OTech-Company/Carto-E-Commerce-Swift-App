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
    @Published var quantity: Int = 0
    @Published private(set) var isFavorite: Bool
    @Published private(set) var isOutOfStock: Bool = false
    @Published var isUpdatingCart: Bool = false

    private let favoritesRepository: FavoritesRepository
    private let cartUseCase: CartUseCaseProtocol
    private var cancellables: Set<AnyCancellable> = []

    var selectedColor: String {
        guard product.colors.indices.contains(selectedColorIndex) else {
            return product.colors.first ?? ""
        }
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
        self.isFavorite = favoritesStore.isFavorite(product.id)

        self.selectedSize = product.sizes.first ?? ""
        self.selectedColorIndex = 0

        let firstVariant = product.variantFor(
            color: product.colors.first ?? "",
            size: product.sizes.first ?? ""
        )
        self.isOutOfStock = (firstVariant?.inventoryQuantity ?? 0) <= 0

        favoritesStore.$favoriteIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                self?.isFavorite = ids.contains(product.id)
            }
            .store(in: &cancellables)

        cartStore.$cart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cart in
                self?.syncQuantityFromCart(cart)
            }
            .store(in: &cancellables)

        $selectedSize
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.onVariantChanged() }
            .store(in: &cancellables)

        $selectedColorIndex
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.onVariantChanged() }
            .store(in: &cancellables)
    }


    func quantityChanged(to newValue: Int) {
        guard !isUpdatingCart else { return }
        let variantId = resolveVariantId()

        if newValue <= 0 {
            if let line = cartLine(for: variantId) {
                Task {
                    isUpdatingCart = true
                    do { _ = try await cartUseCase.removeLine(lineId: line.id) }
                    catch { print("removeLine failed: \(error)") }
                    isUpdatingCart = false
                }
            }
            return
        }

        guard !isOutOfStock else { quantity = 0; return }

        Task {
            isUpdatingCart = true
            do {
                if let line = cartLine(for: variantId) {
                    _ = try await cartUseCase.updateLine(lineId: line.id, quantity: newValue)
                } else {
                    _ = try await cartUseCase.addToCart(
                        product: product,
                        color: selectedColor,
                        size: selectedSize
                    )
                }
            } catch { print("quantityChanged failed: \(error)") }
            isUpdatingCart = false
        }
    }


    func toggleFavorite() {
        if isFavorite {
            favoritesRepository.removeFavorite(productId: product.id)
        } else {
            favoritesRepository.addFavorite(FavoriteItem(product: product))
        }
    }


    private func resolveVariantId() -> String {
        guard let variant = product.variantFor(color: selectedColor, size: selectedSize) else {
            return ""
        }
        return variant.adminGraphqlApiId ?? "gid://shopify/ProductVariant/\(variant.id)"
    }

    private func cartLine(for variantId: String) -> CartLine? {
        CartStateStore.shared.cart?.lines.first { $0.variantId == variantId }
    }

    private func syncQuantityFromCart(_ cart: CartModel?) {
        let variantId = resolveVariantId()
        quantity = cart?.lines.first(where: { $0.variantId == variantId })?.quantity ?? 0
    }

    private func onVariantChanged() {
        let variant = product.variantFor(color: selectedColor, size: selectedSize)
        isOutOfStock = (variant?.inventoryQuantity ?? 0) <= 0
        syncQuantityFromCart(CartStateStore.shared.cart)
    }
}
