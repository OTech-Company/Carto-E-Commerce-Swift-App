//
//  PaymobDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//  Updated on 06/07/2026 to use the Paymob Intention API instead of the
//  legacy Authenticate → Register Order → Payment Key (Accept) flow.
//

import Foundation

// MARK: - Order Items (unchanged, reused by the Intention request)

struct PaymobOrderItem: Encodable {
    let name: String
    let amount_cents: Int
    let quantity: Int
}


struct PaymobBillingData: Encodable {
    let first_name: String
    let last_name: String
    let email: String
    let phone_number: String
    let apartment: String
    let floor: String
    let street: String
    let building: String
    let shipping_method: String
    let postal_code: String
    let city: String
    let country: String
    let state: String
}

// MARK: - Intention API

struct PaymobIntentionItem: Encodable {
    let name: String
    let amount: Int
    let description: String
    let quantity: Int
}

struct PaymobIntentionCustomer: Encodable {
    let first_name: String
    let last_name: String
    let email: String
}

struct PaymobIntentionRequest: Encodable {
    let amount: Int
    let currency: String
    let payment_methods: [Int]
    let items: [PaymobIntentionItem]
    let billing_data: PaymobBillingData
    let customer: PaymobIntentionCustomer
    let special_reference: String
}

struct PaymobIntentionResponse: Decodable {
    let client_secret: String
}

struct PaymobIntention {
    let clientSecret: String
    let publicKey: String
}
