//
//  ProductsInfoViewModel.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

@MainActor
final class ProductsInfoViewModel: ObservableObject {

    let product: Product

    @Published var quantity = 0
    @Published var selectedSize: String
    @Published var selectedColorIndex = 0
    @Published private(set) var isFavorite: Bool

    private let isFavoriteUseCase: IsFavoriteUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase

    init(
        product: Product,
        isFavoriteUseCase: IsFavoriteUseCase,
        addFavoriteUseCase: AddFavoriteUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase
    ) {
        self.product = product
        self.selectedSize = product.sizes.first ?? ""
        self.isFavoriteUseCase = isFavoriteUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.isFavorite = isFavoriteUseCase.execute(productId: product.id)
    }

    func incrementQuantity() {
        quantity += 1
    }

    func decrementQuantity() {
        guard quantity > 0 else { return }
        quantity -= 1
    }

    func toggleFavorite() {
        if isFavorite {
            removeFavoriteUseCase.execute(productId: product.id)
        } else {
            addFavoriteUseCase.execute(product: product)
        }
        isFavorite.toggle()
    }

    func addToCart() {
    }
}
