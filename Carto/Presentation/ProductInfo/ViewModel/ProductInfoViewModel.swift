//
//  ProductsInfoViewModel.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//

import Foundation
import Combine

@MainActor
class ProductsInfoViewModel: ObservableObject {

    @Published private var product: ProductInfo?
    @Published private var isLoading = false
    @Published var errorMessage: String?

    private let useCase: ProductsInfoUseCase

    init(useCase: ProductsInfoUseCase) {
        self.useCase = useCase
    }

    func fetchProduct(productId: String) async {
        isLoading = true

        do {
            product = try await useCase.execute(productId: productId)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
