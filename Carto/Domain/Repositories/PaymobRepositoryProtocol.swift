//
//  PaymobRepositoryProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 08/07/2026.
//

import Foundation

protocol PaymobRepositoryProtocol {
    func createIntention(
        amountCents: Int,
        currency: String,
        merchantOrderId: String,
        items: [PaymobOrderItem],
        billing: PaymobBillingData
    ) async throws -> PaymobIntention
}
