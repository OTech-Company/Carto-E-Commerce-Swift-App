//
//  OrderRepository.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//
import Foundation

final class OrderRepositoryImpl: OrderRepositoryProtocol {
    
    private let adminOrderDataSource: AdminOrderRemoteDataSource
    
    init(adminOrderDataSource: AdminOrderRemoteDataSource = ShopifyAdminOrderRemoteDataSource()) {
        self.adminOrderDataSource = adminOrderDataSource
    }
    
    func fetchOrderHistory() async throws -> [OrderEntity] {
        do {
            
            // 2. Call the client
            let response: OrdersResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .orders,
                queryParams: ["status": "any"]
            )
            
            let dtos = response.orders ?? []
            
            print("=================")
            print("Successfully Decoded Orders DTOs Count: \(dtos.count)")
            print("=================")
            
            // 4. Map directly to domain models using your mapper setup
            return dtos.map { $0.toDomain() }
            
        } catch {
            print("❌ Order Repository Error:", error)
            throw error
        }
    }
    
    func createOrder(cart: CartModel, paymentMethod: PaymentMethod, isPaid: Bool) async throws -> AdminOrder {
        return try await adminOrderDataSource.createOrder(
            cart: cart,
            paymentMethod: paymentMethod,
            isPaid: isPaid
        )
    }
}
