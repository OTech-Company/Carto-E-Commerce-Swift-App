//
//  HomeProductsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 03/07/2026.
//

import Foundation
import Combine

final class HomeProductsViewModel: ObservableObject {
    @Published private(set) var state: LoadState<[Product]> = .idle
    @Published private(set) var products: [Product] = []
    
    private let useCase: ProductUseCaseProtocol
    
    init(useCase: ProductUseCaseProtocol) {
        self.useCase = useCase
    }

    @MainActor
    func loadProducts() async {
        state = .loading
        do {
            let allProducts = try await useCase.execute()
            products = Array(allProducts.prefix(16))
            state = .success(products)
        } catch {
            state = .failure(error)
        }
    }
}
