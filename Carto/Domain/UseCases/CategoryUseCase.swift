//
//  CategoryUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation

final class GetCategoryUseCase{
    private let repository: CategoryRepositoryProtocol
    
    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func executegetCategories() async throws -> [Category] {
        return try await repository.fetchCategories()
    }
    func execute() async throws -> [String] {
        return try await repository.fetchAllAvailableSubcategories()
    }
    func execute(collectionId: String) async throws -> [Subcategory] {
        return try await repository.fetchSubcategoriesWithImages(forCollectionId: collectionId)
    }
}
