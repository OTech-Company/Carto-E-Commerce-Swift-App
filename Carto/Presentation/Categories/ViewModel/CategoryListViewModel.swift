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
    
    /// Entry point to load all initial category data exactly once
    func loadAllDataOnce() async {
        // 💡 GUARD: If we already have a success state with categories, exit immediately
        if case .success = state { return }
        
        // 1. Fetch main categories
        await loadCategories()
        
        // 2. Only proceed if main categories loaded successfully
        if case .success = state {
            print("======")
            await loadSubCategories()
            print("======")
            await loadSubcategories(for: "347833073708")
            await loadSubcategories(for: "347833565228")
        }
    }
    
     func loadCategories() async {
        // Double check guard inside the helper as well
        if case .success = state { return }
        
        state = .loading
        do {
            let categories = try await getCategoryUseCase.executegetCategories()
            state = .success(categories)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    private func loadSubCategories() async {
        do {
            _ = try await getCategoryUseCase.execute()
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
