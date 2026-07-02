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

    @Published var productTypes: [String] = []
    @Published var selectedProductType: String?

    @Published var availableSizes: [String] = []
    @Published var availableColors: [String] = []

    
    @Published var brands: [String] = []
    @Published var colors: [String] = []
    @Published var sizes: [String] = []

    @Published var selectedColors: Set<String> = []
    @Published var selectedSizes: Set<String> = []
    @Published var selectedBrands: Set<String> = []

    @Published var minPrice: Double = 0
    @Published var maxPrice: Double = 1000
    
    @Published var searchBrand = ""

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

            let loadedProducts = try await getCategoryUseCase.execute(categoryId: categoryId)

            products = loadedProducts
            filteredProducts = loadedProducts

            print(products)
            // Available brands
            brands = Array(
                Set(loadedProducts.map(\.vendor))
            ).sorted()

            // Available sizes
            sizes = Array(
                Set(
                    loadedProducts.flatMap {
                        $0.options.first {
                            $0.name.lowercased() == "size"
                        }?.values ?? []
                    }
                )
            ).sorted()

            // Available colors
            colors = Array(
                Set(
                    loadedProducts.flatMap {
                        $0.options.first {
                            $0.name.lowercased() == "color"
                        }?.values ?? []
                    }
                )
            ).sorted()

            productTypes = Array(
                Set(products.map(\.productType))
            ).sorted()
            
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
    func applyFilters() {

        filteredProducts = products.filter { product in

            // Brand
            if !selectedBrands.isEmpty &&
                !selectedBrands.contains(product.vendor) {
                return false
            }

            // Price

            guard let price = Double(product.variants.first?.price ?? "0") else {
                return false
            }

            if price < minPrice || price > maxPrice {
                return false
            }

            // Color

            if !selectedColors.isEmpty {

                let colors = product.options
                    .first(where: {$0.name.lowercased() == "color"})?
                    .values ?? []

                if selectedColors.isDisjoint(with: Set(colors)) {
                    return false
                }
            }

            // Size

            if !selectedSizes.isEmpty {

                let sizes = product.options
                    .first(where: {$0.name.lowercased() == "size"})?
                    .values ?? []

                if selectedSizes.isDisjoint(with: Set(sizes)) {
                    return false
                }
            }

            // Search

            if !searchText.isEmpty {

                return product.title
                    .localizedCaseInsensitiveContains(searchText)
            }

            return true
        }
    }
    
    func updateAvailableFilters() {

        let filteredProducts: [Product]

        if let selectedProductType {

            filteredProducts = products.filter {
                $0.productType == selectedProductType
            }

        } else {

            filteredProducts = products
        }

        availableSizes = Array(
            Set(
                filteredProducts.compactMap {

                    $0.options.indices.contains(0)
                    ? $0.options[0].values.first
                    : nil
                }
            )
        )
        .filter { !$0.isEmpty }
        .sorted()

        availableColors = Array(
            Set(
                filteredProducts.compactMap {

                    $0.options.indices.contains(1)
                    ? $0.options[1].values.first
                    : nil
                }
            )
        )
        .filter { !$0.isEmpty }
        .sorted()
    }
    
}
