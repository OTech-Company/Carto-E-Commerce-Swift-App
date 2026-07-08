//
//  OrderRepository.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//
import Foundation

final class OrderRepositoryImpl: OrderRepositoryProtocol {
    
    private let adminOrderDataSource: AdminOrderRemoteDataSource
    private let remoteDataSource: OrderRemoteDataSource
    
    init(
        adminOrderDataSource: AdminOrderRemoteDataSource = ShopifyAdminOrderRemoteDataSource(),
        remoteDataSource: OrderRemoteDataSource = OrderGraphQLRemoteDataSource()
    ) {
        self.adminOrderDataSource = adminOrderDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Fetch Orders (Storefront)
    func fetchOrderHistory(accessToken: String, first: Int = 20, after: String? = nil) async throws -> StorefrontPage<CustomerOrder> {
        do {
            let storefrontPage = try await remoteDataSource.fetchOrders(
                accessToken: accessToken,
                first: first,
                after: after
            )
            
            print("=================")
            print("Successfully Fetched Orders Count: \(storefrontPage.items.count)")
            print("=================")
            
            return storefrontPage
        } catch {
            print("❌ Order Repository Error (Fetch Orders):", error)
            throw error
        }
    }
    
    // MARK: - Fetch Order Detail (Storefront)
    func fetchOrderDetail(id: String) async throws -> CustomerOrderDetail? {
        do {
            let orderDetail = try await remoteDataSource.fetchOrderDetail(id: id)
            return orderDetail
        } catch {
            print("❌ Order Repository Error (Fetch Order Detail):", error)
            throw error
        }
    }
    
    // MARK: - Create Order (Admin)
    func createOrder(cart: CartModel, paymentMethod: PaymentMethod, isPaid: Bool) async throws -> AdminOrder {
        return try await adminOrderDataSource.createOrder(
            cart: cart,
            paymentMethod: paymentMethod,
            isPaid: isPaid
        )
    }
}
