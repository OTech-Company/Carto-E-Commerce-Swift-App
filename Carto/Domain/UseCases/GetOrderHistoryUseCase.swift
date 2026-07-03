//
//  OrderRepositoryProtocol.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//


import Foundation

final class GetOrderHistoryUseCase {
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [OrderEntity] {
        let orders = try await repository.fetchOrderHistory()
        // Core business rule logic: Always sort history with the newest orders appearing first
        return orders.sorted { $0.id > $1.id }
    }
}
