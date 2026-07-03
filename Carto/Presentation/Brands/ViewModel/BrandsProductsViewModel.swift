//
//  BrandsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import Foundation
import Combine

class BrandsProductsViewModel: ObservableObject {
    @Published private(set) var state: LoadState<[Product]> = .idle
    @Published private(set) var products: [Product] = []
    
    private let useCase: ProductsUseCase
    
    init(useCase: ProductsUseCase) {
        self.useCase = useCase
    }

    @MainActor
    func loadProducts(brandId: Int) async {
        state = .loading
        do {
            products = try await useCase.execute(brandId: brandId)
            state = .success(products)
        } catch {
            state = .failure(error)
        }
    }
}
