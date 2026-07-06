//
//  CartoAIOutfitViewModel.swift
//  Carto
//
//  Created by Ossama Abdellatif on 06/07/2026.
//

import Foundation
import Combine

@MainActor
class CartAiOutfitViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var outfitResult: AIOutfitResponse? = nil
    @Published var recommendedProducts: [Product] = []
    
    let suggestionChips: [String] = ["Summer", "Formal", "Wedding", "Casual"]
    
    private let runOutfitSuggestionsUseCase: GenerateOutfitSuggestionsUseCase
    private let productsUseCase: ProductUseCaseProtocol
    
    init(
        runOutfitSuggestionsUseCase: GenerateOutfitSuggestionsUseCase,
        productsUseCase: ProductUseCaseProtocol
    ) {
        self.runOutfitSuggestionsUseCase = runOutfitSuggestionsUseCase
        self.productsUseCase = productsUseCase
    }
    
    // Added an explicit flag parameter defaulted to false to completely block accidental trigger requests
    func generateOutfitMatrix(isIntentionalSubmit: Bool = false) async {
        // Guard statement: Absolutely reject any execution if it wasn't triggered by an explicit user action button click
        guard isIntentionalSubmit else { return }
        
        let cleanQuery = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanQuery.isEmpty else { return }
        
        resetState()
        isLoading = true
        
        do {
            let fetchedProducts = try await productsUseCase.execute()
            let response = try await runOutfitSuggestionsUseCase.execute(for: cleanQuery, catalogInventory: fetchedProducts)
            self.outfitResult = response
            
            await hydrateRecommendedProducts(with: response.itemIdsInBundle)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    func selectSuggestionChip(_ chip: String) {
        inputText = "I need an Outfit for \(chip)"
//        Task {
//            await generateOutfitMatrix(isIntentionalSubmit: true)
//        }
    }
    
    func clearForm() {
        inputText = ""
        resetState()
    }
    
    private func resetState() {
        errorMessage = nil
        outfitResult = nil
        recommendedProducts = []
    }
    
    private func hydrateRecommendedProducts(with ids: [Int]) async {
        var localProducts: [Product] = []
        for id in ids {
            if let product = try? await productsUseCase.execute(productId: id) {
                localProducts.append(product)
            }
        }
        self.recommendedProducts = localProducts
    }
}
