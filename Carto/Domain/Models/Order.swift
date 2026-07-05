//
//  Order.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct CustomerOrderDetail {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String
    let fulfillmentStatus: String
    let email: String?
    let phone: String?
    let subtotal: String?
    let shipping: String?
    let tax: String?
    let total: String
    let currencyCode: String
    let shippingAddress: OrderShippingAddress?
    let trackingNumbers: [String]
    let lineItems: [OrderLineItemDetail]
}

struct OrderShippingAddress {
    let name: String?
    let address1: String
    let address2: String?
    let city: String
    let province: String?
    let country: String
    let zip: String
}

struct OrderLineItemDetail {
    let title: String
    let quantity: Int
    let variantTitle: String?
    let imageURL: String?
    let price: String?
}
