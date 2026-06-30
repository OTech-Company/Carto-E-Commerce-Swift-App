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
    
    private let getCategoryUseCase: GetCategoryUseCase
    
    enum State {
        case loading
        case success([Category])
        case error(String)
    }
    
    init(getCategoryUseCase: GetCategoryUseCase) {
        self.getCategoryUseCase = getCategoryUseCase
    }
    
    func loadCategories() async {
        state = .loading
        do {
            let categories = try await getCategoryUseCase.execute()
            state = .success(categories)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
