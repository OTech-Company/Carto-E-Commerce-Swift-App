//
//  OrderRepository.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//
import Foundation

final class OrderRepository: OrderRepositoryProtocol {
    
    func fetchOrderHistory() async throws -> [OrderEntity] {
        do {
            // 1. Define the wrapper using CAMEL CASE to perfectly match `.convertFromSnakeCase`
            // Shopify's raw key is "orders" -> converts natively to "orders" in camelCase
            struct OrdersResponse: Decodable {
                let orders: [OrderDTO]?
            }
            
            // 2. Call the client
            let response: OrdersResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .orders, // Ensure this matches your ShopifyEndpoint enum variant name
                queryParams: ["status": "any"] // Retrieves all open, closed, or canceled orders
            )
            
            // 3. Extract using camelCase
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
}
