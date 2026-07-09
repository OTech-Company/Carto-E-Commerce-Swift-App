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
    @Published private(set) var cartQuantity: Int = 0
    @Published private(set) var isOutOfStock: Bool
    
    @Published var showAuthAlert: Bool = false
    
    private var isAuthenticated: Bool {
        AuthSession.shared.sessionState.isAuthenticated
    }
    private let repository: FavoritesRepository
    private let cartUseCase: CartUseCaseProtocol
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
        self.isFavorite = favoritesStore.isFavorite(product.id)

        let firstVariant = product.variants.first
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
                guard let self else { return }
                let variantIds = self.product.variants.compactMap {
                    $0.adminGraphqlApiId ?? "gid://shopify/ProductVariant/\($0.id)"
                }
                self.cartQuantity = cart?.lines
                    .filter { variantIds.contains($0.variantId) }
                    .reduce(0) { $0 + $1.quantity } ?? 0
            }
            .store(in: &cancellables)
    }

    func toggleFavorite(for product: Product) {
        guard isAuthenticated else {
            showAuthAlert = true
            return
        }
        
        if isFavorite {
            repository.removeFavorite(productId: product.id)
        } else {
            repository.addFavorite(FavoriteItem(product: product))
        }
    }

    func addToCart() {
        guard isAuthenticated else {
            showAuthAlert = true
            return
        }
        
        let color = product.colors.first ?? ""
        let size  = product.sizes.first ?? ""
        Task {
            do { _ = try await cartUseCase.addToCart(product: product, color: color, size: size) }
            catch { print("addToCart failed: \(error)") }
        }
    }

    func incrementQuantity() {
        guard isAuthenticated else {
            showAuthAlert = true
            return
        }
        
        guard let line = currentLine() else { addToCart(); return }
        Task {
            do { _ = try await cartUseCase.incrementLine(line) }
            catch { print("increment failed: \(error)") }
        }
    }

    func decrementQuantity() {
        guard isAuthenticated else {
            showAuthAlert = true
            return
        }
        
        guard let line = currentLine() else { return }
        Task {
            do { _ = try await cartUseCase.decrementLine(line) }
            catch { print("decrement failed: \(error)") }
        }
    }

    private func currentLine() -> CartLine? {
        let variantIds = product.variants.compactMap {
            $0.adminGraphqlApiId ?? "gid://shopify/ProductVariant/\($0.id)"
        }
        return CartStateStore.shared.cart?.lines.first { variantIds.contains($0.variantId) }
    }
    
    func logout() async {
        await DIContainer.shared.authRepository.signOut()
    }
}
