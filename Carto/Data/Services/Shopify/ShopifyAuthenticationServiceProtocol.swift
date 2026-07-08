//
//  Payment.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation

struct ShopifyAuthResult {
    let shopifyCustomerId: String
    let customerAccessToken: String
}

// MARK: - Protocol

protocol ShopifyAuthenticationServiceProtocol {

    func createCustomer(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> String


    func createAccessToken(
        email: String,
        password: String
    ) async throws -> String

    func updateCustomerPassword(
        shopifyCustomerId: String,
        newPassword: String
    ) async throws
}
