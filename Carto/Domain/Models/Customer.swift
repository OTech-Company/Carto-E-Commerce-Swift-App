//
//  Customer.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct Customer {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let defaultAddress: CustomerAddress?
    let addresses: [CustomerAddress]
    let orders: [CustomerOrder]
}

struct CustomerAddress {
    let id: String
    let address1: String
    let address2: String?
    let city: String
    let province: String?
    let country: String
    let zip: String
}

struct CustomerOrder {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String
    let fulfillmentStatus: String
    let totalPrice: String
    let currencyCode: String
    let lineItems: [CustomerOrderLineItem]
}

struct CustomerOrderLineItem {
    let title: String
    let quantity: Int
}

struct CustomerAuthToken {
    let accessToken: String
    let expiresAt: String
}
