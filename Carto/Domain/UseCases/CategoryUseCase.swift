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
    
    func execute() async throws -> [Category] {
        return try await repository.fetchCategories()
    }
}
