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
    @Published private(set) var isFavorite = false

    init(product: Product) {
        self.product = product
        self.selectedSize = product.sizes.first ?? ""
    }

    func incrementQuantity() {
        quantity += 1
    }

    func decrementQuantity() {
        guard quantity > 0 else { return }
        quantity -= 1
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    func addToCart() {
        
    }
}
