//
//  PaymobRepositoryImpl.swift
//  Carto
//
//  Created by Mohamed Ayman on 08/07/2026.
//

import Foundation

final class PaymobRepositoryImpl: PaymobRepositoryProtocol {
    
    private let remoteDataSource: PaymobRemoteDataSource
    
    init(remoteDataSource: PaymobRemoteDataSource = PaymobAPIRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func createIntention(
        amountCents: Int,
        currency: String,
        merchantOrderId: String,
        items: [PaymobOrderItem],
        billing: PaymobBillingData
    ) async throws -> PaymobIntention {
        return try await remoteDataSource.createIntention(
            amountCents: amountCents,
            currency: currency,
            merchantOrderId: merchantOrderId,
            items: items,
            billing: billing
        )
    }
}
