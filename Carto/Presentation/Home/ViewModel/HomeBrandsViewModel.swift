//
//  HomeBrandsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Combine
import Foundation

enum LoadState<T> {
    case idle
    case loading
    case success(T)
    case failure(Error)
}

final class HomeBrandsViewModel: ObservableObject {
    @Published private(set) var state: LoadState<[BrandEntity]> = .idle
    @Published private(set) var brands: [BrandEntity] = []
    
    private let useCase: BrandsUseCaseProtocol
    
    init(useCase: BrandsUseCaseProtocol) {
        self.useCase = useCase
    }

    @MainActor
    func loadBrands() async {
        state = .loading
        do {
            brands = try await useCase.fetchBrands()
            state = .success(brands)
        } catch {
            state = .failure(error)
        }
    }
}
