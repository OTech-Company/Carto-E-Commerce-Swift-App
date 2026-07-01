//
//  CategoryViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//

import Foundation

@MainActor
final class CategoryProductsViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []

    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var showFilters = false

    private let getCategoryUseCase: GetCategoryUseCase

    init(getCategoryUseCase: GetCategoryUseCase) {
        self.getCategoryUseCase = getCategoryUseCase
    }

    func loadProducts(categoryId: String) async {

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let products = try await getCategoryUseCase.execute(categoryId: categoryId)

            self.products = products
            self.filteredProducts = products

        } catch {

            errorMessage = error.localizedDescription
        }
    }

    func search() {

        guard !searchText.isEmpty else {

            filteredProducts = products
            return
        }

        filteredProducts = products.filter {

            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
}
