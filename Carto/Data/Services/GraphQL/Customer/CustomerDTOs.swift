//
//  CustomerDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Variables

struct StorefrontCustomerVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
}

struct StorefrontCustomerAccessTokenCreateInput: Encodable {
    let email: String
    let password: String
}

struct StorefrontCustomerAccessTokenCreateVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let input: StorefrontCustomerAccessTokenCreateInput
}

struct StorefrontCustomerAccessTokenDeleteVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
}

struct StorefrontCustomerCreateInput: Encodable {
    let email: String
    let password: String
    let firstName: String?
    let lastName: String?
}

struct StorefrontCustomerCreateVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let input: StorefrontCustomerCreateInput
}

// MARK: - Responses

struct StorefrontCustomerResponse: Decodable {
    let customer: StorefrontCustomer?
}

struct StorefrontCustomerAccessTokenCreateResponse: Decodable {
    let customerAccessTokenCreate: StorefrontCustomerAccessTokenCreatePayload
}

struct StorefrontCustomerAccessTokenDeleteResponse: Decodable {
    let customerAccessTokenDelete: StorefrontCustomerAccessTokenDeletePayload?
}

struct StorefrontCustomerCreateResponse: Decodable {
    let customerCreate: StorefrontCustomerCreatePayload
}

struct StorefrontCustomerAccessTokenCreatePayload: Decodable {
    let customerAccessToken: StorefrontCustomerAccessToken?
    let customerUserErrors: [StorefrontUserError]
}

struct StorefrontCustomerAccessTokenDeletePayload: Decodable {
    let deletedAccessToken: String?
    let userErrors: [StorefrontUserError]
}

struct StorefrontCustomerCreatePayload: Decodable {
    let customer: StorefrontCustomerProfile?
    let customerUserErrors: [StorefrontUserError]
}

struct StorefrontUserError: Decodable {
    let field: [String]?
    let message: String
}

struct StorefrontCustomerAccessToken: Decodable {
    let accessToken: String
    let expiresAt: String
}

// MARK: - Models

struct StorefrontCustomer: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
    let defaultAddress: StorefrontAddress?
    let addresses: StorefrontConnection<StorefrontAddress>
    let orders: StorefrontConnection<StorefrontOrder>
}

struct StorefrontCustomerProfile: Decodable { // This struct is used when creating a customer.
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let phone: String?
}

struct StorefrontAddress: Decodable {
    let id: String
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let firstName: String?
    let lastName: String?
    let company: String?
}

struct StorefrontOrder: Decodable {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalPrice: StorefrontMoney
    let lineItems: StorefrontConnection<StorefrontOrderLineItem>
}

struct StorefrontOrderLineItem: Decodable {
    let title: String
    let quantity: Int
}
