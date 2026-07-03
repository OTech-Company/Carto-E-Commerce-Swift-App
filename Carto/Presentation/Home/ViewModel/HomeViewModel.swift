//
//  HomeViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    let brandVM: HomeBrandsViewModel
    let productVM: HomeProductsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(brandVM: HomeBrandsViewModel, productVM: HomeProductsViewModel) {
        self.brandVM = brandVM
        self.productVM = productVM
        
        brandVM.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        productVM.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    func loadAllData() async {
        async let brands: () = brandVM.loadBrands()
        async let products: () = productVM.loadProducts()
        _ = await [brands, products]
    }
}
