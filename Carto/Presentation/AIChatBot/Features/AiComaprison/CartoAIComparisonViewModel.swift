//
//  CartoAIComparisonViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import Foundation
import Combine

@MainActor
final class CartoAIComparisonViewModel: ObservableObject {
    // MARK: - Input State
    @Published var firstQuery: String = ""
    @Published var secondQuery: String = ""
    
    let suggestionChips: [String] = ["Running Shoes vs Trainers", "iPhone 15 vs iPhone 16", "Hoodies vs Jackets"]

    // MARK: - Selection State
    @Published var selectedFirstProduct: Product? = nil {
        didSet { clearRecommendations() }
    }
    @Published var selectedSecondProduct: Product? = nil {
        didSet { clearRecommendations() }
    }
    
    // MARK: - Search Recommendations Output
    @Published var firstProductRecommendations: [Product] = []
    @Published var secondProductRecommendations: [Product] = []
    
    // MARK: - UI Processing & Results State
    @Published var isLoading: Bool = false
    @Published var comparisonResult: AIComparisonResponse? = nil
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let compareUseCase: CompareProductsUseCase
    private let productsUseCase: ProductUseCaseProtocol
    
    // MARK: - Private Core Storage
    private var allProductsCatalog: [Product] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Flag to stop selection text updates from re-triggering search dropdowns
    private var isSelectingProduct: Bool = false
    
    init(compareUseCase: CompareProductsUseCase, productsUseCase: ProductUseCaseProtocol) {
        self.compareUseCase = compareUseCase
        self.productsUseCase = productsUseCase
        
        setupSearchDebouncing()
        Task { await loadProductCatalog() }
    }
    
    // MARK: - Pre-fetch Catalog
    private func loadProductCatalog() async {
        do {
            self.allProductsCatalog = try await productsUseCase.execute()
        } catch {
            self.errorMessage = "Failed to synchronize product catalog records."
        }
    }
    
    // MARK: - Reactive Type-Ahead Filtering Setup
    private func setupSearchDebouncing() {
        // Debounce stream for Input Field 1
        $firstQuery
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                // Bypass search if we just programmatically selected an item
                if self.isSelectingProduct { return }
                self.firstProductRecommendations = self.filterCatalog(for: query, excluding: self.selectedSecondProduct)
            }
            .store(in: &cancellables)
            
        // Debounce stream for Input Field 2
        $secondQuery
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                // Bypass search if we just programmatically selected an item
                if self.isSelectingProduct { return }
                self.secondProductRecommendations = self.filterCatalog(for: query, excluding: self.selectedFirstProduct)
            }
            .store(in: &cancellables)
    }
    
    private func filterCatalog(for query: String, excluding excludedProduct: Product?) -> [Product] {
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !cleanQuery.isEmpty else { return [] }
        
        return allProductsCatalog.filter { product in
            let displayTitle = self.cleanTitle(product.title).lowercased()
            let rawTitle = product.title.lowercased()
            
            let matchesQuery = rawTitle.contains(cleanQuery) ||
                               displayTitle.contains(cleanQuery) ||
                               product.vendor.lowercased().contains(cleanQuery) ||
                               product.productType.lowercased().contains(cleanQuery)
            
            let isNotExcluded = product.id != excludedProduct?.id
            return matchesQuery && isNotExcluded
        }
    }
    
    private func clearRecommendations() {
        firstProductRecommendations = []
        secondProductRecommendations = []
    }
    
    // MARK: - Helper Formatting Logic
    private func cleanTitle(_ title: String) -> String {
        if let separatorIndex = title.firstIndex(of: "|") {
            return title[title.index(after: separatorIndex)...].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return title
    }
    
    // MARK: - User Intent Actions
    func selectFirstProduct(_ product: Product) {
        isSelectingProduct = true
        selectedFirstProduct = product
        firstQuery = cleanTitle(product.title)
        
        // Reset flag after state settles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSelectingProduct = false
        }
    }
    
    func selectSecondProduct(_ product: Product) {
        isSelectingProduct = true
        selectedSecondProduct = product
        secondQuery = cleanTitle(product.title)
        
        // Reset flag after state settles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSelectingProduct = false
        }
    }
    
    func clearForm() {
        firstQuery = ""
        secondQuery = ""
        selectedFirstProduct = nil
        selectedSecondProduct = nil
        comparisonResult = nil
        errorMessage = nil
        clearRecommendations()
    }
    
    func submitComparison() async {
        guard let first = selectedFirstProduct, let second = selectedSecondProduct else {
            self.errorMessage = "Please explicitly select two matching products from the recommendations."
            return
        }
        
        errorMessage = nil
        isLoading = true
        comparisonResult = nil
        
        do {
            let response = try await compareUseCase.execute(productsToCompare: [first, second])
            self.comparisonResult = response
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
