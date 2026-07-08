//
//  OrderUseCase.swift
//  Carto
//
//  Created by osama hosam on 08/07/2026.
//

import Foundation

protocol OrderUseCaseProtocol {
    func fetchHistory(accessToken: String, first: Int, after: String?) async throws -> StorefrontPage<CustomerOrder>
    func fetchDetails(id: String) async throws -> CustomerOrderDetail?
}

final class OrderUseCase: OrderUseCaseProtocol {
    
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchHistory(accessToken: String, first: Int = 20, after: String? = nil) async throws -> StorefrontPage<CustomerOrder> {
        guard !accessToken.isEmpty else {
            throw OrderUseCaseError.invalidToken
        }
        
        return try await repository.fetchOrderHistory(
            accessToken: accessToken,
            first: first,
            after: after
        )
    }
    
    func fetchDetails(id: String) async throws -> CustomerOrderDetail? {
        guard !id.isEmpty else {
            throw OrderUseCaseError.invalidOrderId
        }
        
        return try await repository.fetchOrderDetail(id: id)
    }
}

// MARK: - Use Case Errors
enum OrderUseCaseError: Error {
    case invalidToken
    case invalidOrderId
}
