//
//  AIFeatureSheetViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import Foundation
import Combine

@MainActor
final class AIFeatureSheetViewModel: ObservableObject {
    @Published var selectedFeatureRoute: FeatureRoute? = nil
    @Published var activeProcessingState: Bool = false
    
    enum FeatureRoute: Identifiable {
        case chat, comparison, outfit, insights
        var id: Int { self.hashValue }
    }
    
    // Injected Architecture Use Cases
    private let compareProductsUseCase: CompareProductsUseCase
    private let generateOutfitSuggestionsUseCase: GenerateOutfitSuggestionsUseCase
    private let generatePersonalizedInsightsUseCase: GeneratePersonalizedInsightsUseCase
    
    init(
        compareProductsUseCase: CompareProductsUseCase,
        generateOutfitSuggestionsUseCase: GenerateOutfitSuggestionsUseCase,
        generatePersonalizedInsightsUseCase: GeneratePersonalizedInsightsUseCase
    ) {
        self.compareProductsUseCase = compareProductsUseCase
        self.generateOutfitSuggestionsUseCase = generateOutfitSuggestionsUseCase
        self.generatePersonalizedInsightsUseCase = generatePersonalizedInsightsUseCase
    }
    
    func executeOutfitGeneration() async {
        activeProcessingState = true
        do {
            let outfit: AIOutfitResponse = try await generateOutfitSuggestionsUseCase.execute(
                for: "Summer Beach Wedding Gala",
                catalogInventory: [] // Reference local app cache or persistence store
            )
            print("Successfully compiled Outfit Bundle: \(outfit.outfitTitle)")
            // Trigger visual route modal or navigation flow state here
        } catch {
            print("Domain architecture compilation error: \(error)")
        }
        activeProcessingState = false
    }
}
