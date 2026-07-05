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
    @Published var quantity = 0
    @Published var selectedSize: String
    @Published var selectedColorIndex = 0
    @Published private(set) var isFavorite: Bool

    private let repository: FavoritesRepository
    private var cancellable: AnyCancellable?

    init(
        product: Product,
        repository: FavoritesRepository,
        store: FavoritesStateStore = .shared
    ) {
        self.product = product
        self.selectedSize = product.sizes.first ?? ""
        self.repository = repository
        self.isFavorite = store.isFavorite(product.id)

        cancellable = store.$favoriteIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                guard let self else { return }
                self.isFavorite = ids.contains(self.product.id)
            }
    }

    func incrementQuantity() { quantity += 1 }
    func decrementQuantity() { if quantity > 0 { quantity -= 1 } }

    func toggleFavorite() {
        if isFavorite {
            repository.removeFavorite(productId: product.id)
        } else {
            repository.addFavorite(FavoriteItem(product: product))
        }
    }

    func addToCart() {}
}
