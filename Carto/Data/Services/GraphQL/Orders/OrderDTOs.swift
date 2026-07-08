//
//  OrderDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Variables

struct StorefrontOrdersVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
    let first: Int
    let after: String?
}

struct StorefrontOrderDetailVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let id: String
}

// MARK: - Responses


struct StorefrontOrdersResponse: Decodable {
    let customer: StorefrontOrdersCustomer?
}

struct StorefrontOrdersCustomer: Decodable {
    let orders: StorefrontConnection<StorefrontOrder>
}

struct StorefrontOrderDetailResponse: Decodable {
    let node: StorefrontOrderDetail?
}

// MARK: - Models

struct StorefrontOrderDetail: Decodable {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String?
    let fulfillmentStatus: String?
    let email: String?
    let phone: String?
    let subtotalPrice: StorefrontMoney?
    let totalShippingPrice: StorefrontMoney?
    let totalTax: StorefrontMoney?
    let totalPrice: StorefrontMoney
    let shippingAddress: StorefrontOrderAddress?
    let successfulFulfillments: [StorefrontFulfillment]?
    let lineItems: StorefrontConnection<StorefrontOrderLineItemDetail>
}

struct StorefrontOrderAddress: Decodable {
    let name: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
}

struct StorefrontFulfillment: Decodable {
    let trackingCompany: String?
    let trackingInfo: [StorefrontTrackingInfo]
}

struct StorefrontTrackingInfo: Decodable {
    let number: String?
    let url: String?
}

struct StorefrontOrderLineItemDetail: Decodable {
    let title: String
    let quantity: Int
    let variant: StorefrontOrderLineItemVariant?
}

struct StorefrontOrderLineItemVariant: Decodable {
    let id: String
    let title: String
    let price: StorefrontMoney
    let image: StorefrontImage?
}
