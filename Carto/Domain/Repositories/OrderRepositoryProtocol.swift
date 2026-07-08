//
//  OrderRepositoryProtocol.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//


import Foundation

protocol OrderRepositoryProtocol {
    func fetchOrderHistory() async throws -> [OrderEntity]
    func createOrder(cart: CartModel, paymentMethod: PaymentMethod, isPaid: Bool) async throws -> AdminOrder
}
