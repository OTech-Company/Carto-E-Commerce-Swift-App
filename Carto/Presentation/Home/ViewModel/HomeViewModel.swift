//
//  HomeViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    let brandVM: HomeBrandsViewModel
    let productVM: HomeProductsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showAuthAlert: Bool = false
    private var isAuthenticated: Bool {
        AuthSession.shared.sessionState.isAuthenticated
    }
    
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
        async let brands: Void = brandVM.loadBrands()
        async let products: Void = productVM.loadProducts()
        _ = await (brands, products)
    }
    
    func openCart(onSuccess: () -> Void) {
        guard isAuthenticated else {
            showAuthAlert = true
            return
        }

        onSuccess()
    }
    
    func logout() async {
        await DIContainer.shared.authRepository.signOut()
    }
}
