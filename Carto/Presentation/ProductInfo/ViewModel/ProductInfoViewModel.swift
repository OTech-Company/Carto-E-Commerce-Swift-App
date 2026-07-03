//
//  ProductsInfoViewModel.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation
import Combine

@MainActor
final class ProductsInfoViewModel: ObservableObject {

    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let useCase: ProductsUseCase

    init(useCase: ProductsUseCase) {
        self.useCase = useCase
    }

    func fetchProduct(productId: Int) async {
        isLoading = true
        errorMessage = nil 

        do {
            product = try await useCase.execute(productId: productId)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
}
