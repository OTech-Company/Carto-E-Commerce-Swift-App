//
//  OrderHistoryViewModel.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation
import SwiftUI

@MainActor
final class OrderHistoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var orders: [CustomerOrder] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Pagination tracking state
    private var hasNextPage: Bool = false
    private var endCursor: String? = nil
    
    // MARK: - Dependencies
    private let orderUseCase: OrderUseCaseProtocol
    
    // MARK: - Initializer
    init(orderUseCase: OrderUseCaseProtocol) {
        self.orderUseCase = orderUseCase
    }
    
    // MARK: - Intent Actions
    
    /// Fetches the initial list of orders or resets the state.
    /// - Parameter accessToken: The active customer session token.
    func fetchOrders(accessToken: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let page = try await orderUseCase.fetchHistory(
                accessToken: accessToken,
                first: 20,
                after: nil
            )
            print(page)
            self.orders = page.items
            self.hasNextPage = page.hasNextPage
            self.endCursor = page.endCursor
        } catch {
            print("❌ ViewModel Error (Initial Fetch): \(error)")
            self.errorMessage = "Unable to fetch your order history. Please make sure you are signed in and try again later."
        }
        
        isLoading = false
    }
    
    /// Triggered when the user scrolls to the bottom of the list to load more records.
    /// - Parameter accessToken: The active customer session token.
    func fetchNextPageIfNeeded(accessToken: String) async {
        guard hasNextPage, let cursor = endCursor, !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let nextPage = try await orderUseCase.fetchHistory(
                accessToken: accessToken,
                first: 20,
                after: cursor
            )
            
            self.orders.append(contentsOf: nextPage.items)
            self.hasNextPage = nextPage.hasNextPage
            self.endCursor = nextPage.endCursor
        } catch {
            print("❌ ViewModel Error (Pagination Fetch): \(error)")
            // Don't wipe existing loaded orders on secondary page failure, just bubble up the string
            self.errorMessage = "Failed to load additional orders."
        }
        
        isLoading = false
    }
}
