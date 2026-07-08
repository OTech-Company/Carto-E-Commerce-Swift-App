//
//  PaymentDemoViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

@MainActor
final class PaymentDemoViewModel: ObservableObject {

    // MARK: - State

    enum State: Equatable {
        case idle
        case loading
        case ready(CartModel)
        case failed(String)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading):
                return true
            case (.ready(let a), .ready(let b)):
                return a.id == b.id
            case (.failed(let a), .failed(let b)):
                return a == b
            default:
                return false
            }
        }
    }

    @Published private(set) var state: State = .idle

    // MARK: - Dependencies (existing architecture, unchanged)

    private let productsDataSource: StorefrontProductsRemoteDataSourceProtocol
    private let cartDataSource: CartRemoteDataSource

    init(
        productsDataSource: StorefrontProductsRemoteDataSourceProtocol = StorefrontProductsRemoteDataSource(),
        cartDataSource: CartRemoteDataSource = CartGraphQLRemoteDataSource()
    ) {
        self.productsDataSource = productsDataSource
        self.cartDataSource = cartDataSource
    }

    // MARK: - Actions

    func createRealCart() async {
        state = .loading

        do {
            let page = try await productsDataSource.fetchProducts(first: 5, after: nil)

            guard let variant = firstPurchasableVariant(in: page.items) else {
                state = .failed("No purchasable products found in the store to build a demo cart.")
                return
            }

            let cart = try await cartDataSource.createCart(
                lines: [
                    StorefrontCartLineInput(
                        merchandiseId: variant.merchandiseId,
                        quantity: 1,
                        attributes: nil
                    )
                ]
            )

            state = .ready(cart)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func reset() {
        state = .idle
    }

    // MARK: - Helpers

    private func firstPurchasableVariant(in products: [STProduct]) -> STVariant? {
        for product in products {
            if let available = product.variants.first(where: { $0.availableForSale }) {
                return available
            }
        }
        return products.first?.variants.first
    }
}
