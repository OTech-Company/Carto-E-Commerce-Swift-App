//
//  OrderRepositoryProtocol.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation


protocol OrderRepositoryProtocol {
    

    func fetchOrderHistory(
        accessToken: String,
        first: Int,
        after: String?
    ) async throws -> StorefrontPage<CustomerOrder>

    func fetchOrderDetail(id: String) async throws -> CustomerOrderDetail?
    

    func createOrder(
        cart: CartModel,
        paymentMethod: PaymentMethod,
        isPaid: Bool
    ) async throws -> AdminOrder
}
