//
//  AdminOrderRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

protocol AdminOrderRemoteDataSource {
    func createOrder(cart: CartModel, paymentMethod: PaymentMethod, isPaid: Bool) async throws -> AdminOrder
}

final class ShopifyAdminOrderRemoteDataSource: AdminOrderRemoteDataSource {

    private let client: AdminGraphQLClient

    init(client: AdminGraphQLClient = ShopifyAdminGraphQLClient.shared) {
        self.client = client
    }

    func createOrder(cart: CartModel, paymentMethod: PaymentMethod, isPaid: Bool) async throws -> AdminOrder {
        let lineItems = cart.lines.map {
            AdminOrderLineItemInput(variantId: $0.variantId, quantity: $0.quantity)
        }

        let transaction = AdminOrderTransactionInput(
            kind: "SALE",
            status: isPaid ? "SUCCESS" : "PENDING",
            amountSet: AdminMoneyInput(
                shopMoney: AdminShopMoneyInput(amount: cart.total, currencyCode: cart.currencyCode)
            ),
            gateway: paymentMethod.gatewayName
        )

        let input = AdminOrderCreateInput(
            lineItems: lineItems,
            financialStatus: isPaid ? "PAID" : "PENDING",
            transactions: [transaction],
            email: nil,
            note: "Created via Carto iOS app — payment method: \(paymentMethod.displayName)"
        )

        let request = GraphQLRequest(
            query: AdminOrderQueries.orderCreate,
            variables: AdminOrderCreateVariables(
                order: input,
                options: AdminOrderCreateOptionsInput(sendReceipt: true)
            ),
            operationName: "OrderCreate"
        )

        let response: AdminOrderCreateResponse = try await client.request(request)
        return try response.orderCreate.toDomain()
    }
}
