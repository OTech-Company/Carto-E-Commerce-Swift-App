//
//  PaymobRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation

protocol PaymobRemoteDataSource {
    func createIntention(
        amountCents: Int,
        currency: String,
        merchantOrderId: String,
        items: [PaymobOrderItem],
        billing: PaymobBillingData
    ) async throws -> PaymobIntention
}

final class PaymobAPIRemoteDataSource: PaymobRemoteDataSource {

    private let client: PaymobAPIClient

    init(client: PaymobAPIClient = .shared) {
        self.client = client
    }

    func createIntention(
        amountCents: Int,
        currency: String,
        merchantOrderId: String,
        items: [PaymobOrderItem],
        billing: PaymobBillingData
    ) async throws -> PaymobIntention {
        guard
            !PaymobConfiguration.secretKey.isEmpty,
            !PaymobConfiguration.publicKey.isEmpty,
            !PaymobConfiguration.integrationIds.isEmpty
        else {
            throw PaymobError.invalidConfiguration
        }

        let requestBody = PaymobIntentionRequest(
            amount: amountCents,
            currency: currency,
            payment_methods: PaymobConfiguration.integrationIds,
            items: items.map {
                PaymobIntentionItem(name: $0.name, amount: $0.amount_cents, description: $0.name, quantity: $0.quantity)
            },
            billing_data: billing,
            customer: PaymobIntentionCustomer(
                first_name: billing.first_name,
                last_name: billing.last_name,
                email: billing.email
            ),
            special_reference: merchantOrderId
        )

        let response: PaymobIntentionResponse = try await client.post(
            "/v1/intention/",
            body: requestBody,
            headers: ["Authorization": "Token \(PaymobConfiguration.secretKey)"]
        )

        return PaymobIntention(clientSecret: response.client_secret, publicKey: PaymobConfiguration.publicKey)
    }
}
