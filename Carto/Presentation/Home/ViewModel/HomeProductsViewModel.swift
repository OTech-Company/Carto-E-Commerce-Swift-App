//
//  HomeProductsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 03/07/2026.
//
import Foundation
import Combine

@MainActor
final class HomeProductsViewModel: ObservableObject {
    @Published private(set) var state: LoadState<[Product]> = .idle
    
    /// The truncated subset of products displayed on the default home grid layout
    @Published private(set) var homeProducts: [Product] = []
    
    /// The complete unfiltered catalog source used directly by the search overlay view
    private(set) var allProducts: [Product] = []
    
    // MARK: - Dependencies
    private let useCase: ProductUseCaseProtocol
    
    // MARK: - Init
    init(useCase: ProductUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Intent Actions
    func loadProducts() async {
        state = .loading
        do {
            let fetchedCatalog = try await useCase.execute()
            
            // 1. Maintain the complete catalog source for local search routines
            self.allProducts = fetchedCatalog
            
            // 2. Extract only the initial 20 items for standard landing layout optimization
            self.homeProducts = Array(fetchedCatalog.prefix(20))
            
            state = .success(homeProducts)
        } catch {
            state = .failure(error)
        }
    }
}
