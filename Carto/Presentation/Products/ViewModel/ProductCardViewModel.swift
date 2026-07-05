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
    let product: Product
    @Published private(set) var isFavorite: Bool

    private let repository: FavoritesRepository
    private var cancellable: AnyCancellable?

    init(
        product: Product,
        repository: FavoritesRepository,
        store: FavoritesStateStore = .shared
    ) {
        self.product = product
        self.repository = repository
        self.isFavorite = store.isFavorite(product.id)

        cancellable = store.$favoriteIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                guard let self else { return }
                self.isFavorite = ids.contains(self.product.id)
            }
    }

    func toggleFavorite() {
        if isFavorite {
            repository.removeFavorite(productId: product.id)
        } else {
            repository.addFavorite(FavoriteItem(product: product))
        }
    }
}
