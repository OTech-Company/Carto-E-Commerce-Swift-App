//
//  ProductsViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//

import Foundation

@MainActor
final class ProductsViewModel: ObservableObject {

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
    private let getProductByBrand: ProductUseCaseProtocol
    
    init(getCategoryUseCase: GetCategoryUseCase, getProductByBrand: ProductUseCaseProtocol) {
        self.getCategoryUseCase = getCategoryUseCase
        self.getProductByBrand = getProductByBrand
    }

    func loadProducts(categoryId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let loadedProducts = try await getCategoryUseCase.execute(categoryId: categoryId)
            products = loadedProducts
            filteredProducts = loadedProducts

            setupInitialFilters(loadedProducts: loadedProducts)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadProducts(brandId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let loadedProducts = try await getProductByBrand.execute(brandId: brandId)
            products = loadedProducts
            filteredProducts = loadedProducts
            
            setupInitialFilters(loadedProducts: loadedProducts)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Helper Filter Initialization
    private func setupInitialFilters(loadedProducts: [Product]) {
        // Available brands
        brands = Array(Set(loadedProducts.map(\.vendor))).sorted()

        // Available sizes
        sizes = Array(Set(loadedProducts.flatMap {
            $0.options.first { $0.name.lowercased() == "size" }?.values ?? []
        })).sorted()

        // Available colors
        colors = Array(Set(loadedProducts.flatMap {
            $0.options.first { $0.name.lowercased() == "color" }?.values ?? []
        })).sorted()

        productTypes = Array(Set(loadedProducts.map(\.productType))).sorted()
        
        // Fix: Populate available sizes and colors initially so filter UI isn't hidden
        updateAvailableFilters()
    }
    
    // MARK: - Filter Actions
    func search() {
        guard !searchText.isEmpty else {
            applyFilters() // Keep active filtering intact when text changes
            return
        }
        applyFilters()
    }
    
    func applyFilters() {
        filteredProducts = products.filter { product in
            // Product Type
            if let selectedProductType, product.productType != selectedProductType {
                return false
            }

            // Brand
            if !selectedBrands.isEmpty && !selectedBrands.contains(product.vendor) {
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
                let productColors = product.options.first(where: { $0.name.lowercased() == "color" })?.values ?? []
                if selectedColors.isDisjoint(with: Set(productColors)) {
                    return false
                }
            }

            // Size
            if !selectedSizes.isEmpty {
                let productSizes = product.options.first(where: { $0.name.lowercased() == "size" })?.values ?? []
                if selectedSizes.isDisjoint(with: Set(productSizes)) {
                    return false
                }
            }

            // Search Text
            if !searchText.isEmpty {
                return product.title.localizedCaseInsensitiveContains(searchText)
            }

            return true
        }
    }
    
    func clearFilters() {
        selectedProductType = nil
        selectedColors.removeAll()
        selectedSizes.removeAll()
        selectedBrands.removeAll()
        minPrice = 0
        maxPrice = 1000
        updateAvailableFilters()
        filteredProducts = products
    }
    
    func updateAvailableFilters() {
        let targets = selectedProductType != nil
            ? products.filter { $0.productType == selectedProductType }
            : products

        // Fallback safely to full lists if structural parsing produces empty keys
        let derivedSizes = Array(Set(targets.flatMap {
            $0.options.first { $0.name.lowercased() == "size" }?.values ?? []
        })).sorted()
        
        let derivedColors = Array(Set(targets.flatMap {
            $0.options.first { $0.name.lowercased() == "color" }?.values ?? []
        })).sorted()

        availableSizes = derivedSizes.isEmpty ? sizes : derivedSizes
        availableColors = derivedColors.isEmpty ? colors : derivedColors
    }
}
