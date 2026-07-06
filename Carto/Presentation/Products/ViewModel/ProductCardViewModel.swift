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

    private let repository: FavoritesRepository
    private var cancellable: AnyCancellable?
    private let productId: Int

    init(
        productId: Int,
        repository: FavoritesRepository,
        store: FavoritesStateStore = .shared
    ) {
        self.productId = productId
        self.repository = repository
        self.isFavorite = store.isFavorite(productId)

        cancellable = store.$favoriteIds
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ids in
                guard let self else { return }
                self.isFavorite = ids.contains(self.productId)
            }
    }

    func toggleFavorite(for product: Product) {
        if isFavorite {
            repository.removeFavorite(productId: product.id)
        } else {
            repository.addFavorite(FavoriteItem(product: product))
        }
    }
}
