//
//  OrderHistoryViewModel.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

@MainActor
final class OrderHistoryViewModel: ObservableObject {
    
    @Published private(set) var orders: [OrderEntity] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let getOrderHistoryUseCase: GetOrderHistoryUseCase
    
    init(getOrderHistoryUseCase: GetOrderHistoryUseCase) {
        self.getOrderHistoryUseCase = getOrderHistoryUseCase
    }
    
    func fetchOrders() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.orders = try await getOrderHistoryUseCase.execute()
        } catch {
            print("❌ ViewModel Error: \(error)")
            self.errorMessage = "Unable to fetch your order history. Please try again."
        }
        
        isLoading = false
    }
}
