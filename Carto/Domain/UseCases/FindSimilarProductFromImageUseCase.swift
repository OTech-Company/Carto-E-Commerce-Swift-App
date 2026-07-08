//
//  FindSimilarProductFromImageUseCase.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//

import Foundation

protocol FindSimilarProductFromImageUseCase {
    func execute(
        imageData: Data,
        products: [Product]
    ) async -> Product?
}

final class FindSimilarProductFromImageUseCaseImpl: FindSimilarProductFromImageUseCase {

    private let repository: ImageSearchRepository

    init(repository: ImageSearchRepository) {
        self.repository = repository
    }

    func execute(
        imageData: Data,
        products: [Product]
    ) async -> Product? {
        await repository.findMostSimilarProduct(
            to: imageData,
            from: products
        )
    }
}
