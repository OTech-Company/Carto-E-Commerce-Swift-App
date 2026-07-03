//
//  BrandsUseCase.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Foundation

protocol BrandsUseCaseProtocol {
    func fetchBrands() async throws -> [BrandEntity]
}

class BrandsUseCase: BrandsUseCaseProtocol {
    private let repository: BrandsRepoProtocol

    init(repository: BrandsRepoProtocol) {
        self.repository = repository
    }

    func fetchBrands() async throws -> [BrandEntity] {
        return try await repository.fetchBrands()
    }
}
