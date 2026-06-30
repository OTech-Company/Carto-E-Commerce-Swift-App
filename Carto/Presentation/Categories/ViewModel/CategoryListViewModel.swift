//
//  CategoryListViewModel.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation

@MainActor
final class CategoryListViewModel: ObservableObject {
    @Published private(set) var state: State = .loading
    // Stores loaded subcategories mapped by their parent collection ID
    @Published private(set) var subcategoriesByCollection: [String: [Subcategory]] = [:]
    
    private let getCategoryUseCase: GetCategoryUseCase
    private let fetchSubcategoriesUseCase: GetCategoryUseCase // New UseCase Injection
    
    enum State {
        case loading
        case success([Category])
        case error(String)
    }
    
    init(
        getCategoryUseCase: GetCategoryUseCase,
        fetchSubcategoriesUseCase: GetCategoryUseCase
    ) {
        self.getCategoryUseCase = getCategoryUseCase
        self.fetchSubcategoriesUseCase = fetchSubcategoriesUseCase
    }
    
    func loadCategories() async {
        state = .loading
        do {
            let categories = try await getCategoryUseCase.executegetCategories()
            state = .success(categories)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    // Dynamic background loading for subcategories when a parent card appears or is tapped
    func loadSubcategories(for collectionId: String) async {
        guard subcategoriesByCollection[collectionId] == nil else { return } // Already cached
        
        do {
            let subcategories = try await fetchSubcategoriesUseCase.execute(collectionId: collectionId)
            subcategoriesByCollection[collectionId] = subcategories
        } catch {
            print("⚠️ Error loading subcategories for \(collectionId): \(error.localizedDescription)")
        }
    }
}
