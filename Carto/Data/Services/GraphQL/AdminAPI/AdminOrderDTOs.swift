//
//  AdminOrderDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

// MARK: - Inputs

struct AdminOrderLineItemInput: Encodable {
    let variantId: String
    let quantity: Int
}

struct AdminShopMoneyInput: Encodable {
    let amount: String
    let currencyCode: String
}

struct AdminMoneyInput: Encodable {
    let shopMoney: AdminShopMoneyInput
}

struct AdminOrderTransactionInput: Encodable {
    let kind: String
    let status: String 
    let amountSet: AdminMoneyInput
    let gateway: String?
}

struct AdminOrderCreateInput: Encodable {
    let lineItems: [AdminOrderLineItemInput]
    let financialStatus: String?
    let transactions: [AdminOrderTransactionInput]?
    let email: String?
    let note: String?
}

struct AdminOrderCreateOptionsInput: Encodable {
    let sendReceipt: Bool
}

struct AdminOrderCreateVariables: Encodable {
    let order: AdminOrderCreateInput
    let options: AdminOrderCreateOptionsInput?
}

// MARK: - Responses

struct AdminOrderCreateResponse: Decodable {
    let orderCreate: AdminOrderCreatePayload
}

struct AdminOrderCreatePayload: Decodable {
    let order: AdminOrderDTO?
    let userErrors: [AdminUserError]
}

struct AdminUserError: Decodable {
    let field: [String]?
    let message: String
}

// MARK: - Models

struct AdminOrderDTO: Decodable {
    let id: String
    let name: String
    let createdAt: String
    let displayFinancialStatus: String?
    let totalPriceSet: AdminMoneySet
}

struct AdminMoneySet: Decodable {
    let shopMoney: AdminShopMoney
}

struct AdminShopMoney: Decodable {
    let amount: String
    let currencyCode: String
}
