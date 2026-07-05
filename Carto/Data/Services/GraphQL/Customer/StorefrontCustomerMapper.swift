//
//  StorefrontCustomerMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontCustomerError: LocalizedError {
    case userErrors([String])

    var errorDescription: String? {
        switch self {
        case .userErrors(let messages): return messages.joined(separator: "\n")
        }
    }
}

extension StorefrontCustomer {
    func toDomain() -> Customer {
        Customer(
            id: id,
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            email: email ?? "",
            phone: phone,
            defaultAddress: defaultAddress?.toDomain(),
            addresses: addresses.nodes.map { $0.toDomain() },
            orders: orders.nodes.map { $0.toDomain() }
        )
    }
}

extension StorefrontCustomerProfile {
    func toDomain() -> Customer {
        Customer(
            id: id,
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            email: email ?? "",
            phone: phone,
            defaultAddress: nil,
            addresses: [],
            orders: []
        )
    }
}

extension StorefrontAddress {
    func toDomain(isDefault: Bool = false) -> CustomerAddress {
        CustomerAddress(
            id: id,
            address1: address1 ?? "",
            address2: address2,
            city: city ?? "",
            province: province ?? "",
            country: country ?? "",
            zip: zip ?? "",
            phone: phone ?? "",
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            company: company,
            isDefault: isDefault
        )
    }
}

extension StorefrontOrder {
    func toDomain() -> CustomerOrder {
        CustomerOrder(
            id: id,
            orderNumber: orderNumber,
            processedAt: processedAt,
            financialStatus: financialStatus ?? "",
            fulfillmentStatus: fulfillmentStatus ?? "",
            totalPrice: totalPrice.amount,
            currencyCode: totalPrice.currencyCode,
            lineItems: lineItems.nodes.map { $0.toDomain() }
        )
    }
}

extension StorefrontOrderLineItem {
    func toDomain() -> CustomerOrderLineItem {
        CustomerOrderLineItem(title: title, quantity: quantity)
    }
}

extension StorefrontCustomerAccessTokenCreatePayload {
    func toDomain() throws -> CustomerAuthToken {
        guard customerUserErrors.isEmpty else {
            throw StorefrontCustomerError.userErrors(customerUserErrors.map { $0.message })
        }
        guard let token = customerAccessToken else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    StorefrontCustomerAccessToken.self,
                    .init(codingPath: [], debugDescription: "No access token returned")
                )
            )
        }
        return CustomerAuthToken(accessToken: token.accessToken, expiresAt: token.expiresAt)
    }
}

extension StorefrontCustomerCreatePayload {
    func toDomain() throws -> Customer {
        guard customerUserErrors.isEmpty else {
            throw StorefrontCustomerError.userErrors(customerUserErrors.map { $0.message })
        }
        guard let customer else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    StorefrontCustomerProfile.self,
                    .init(codingPath: [], debugDescription: "No customer returned")
                )
            )
        }
        return customer.toDomain()
    }
}
