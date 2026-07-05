//
//  CartDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Inputs

struct StorefrontCartLineInput: Encodable {
    let merchandiseId: String
    let quantity: Int
    let attributes: [StorefrontCartAttributeInput]?
}

struct StorefrontCartAttributeInput: Encodable {
    let key: String
    let value: String?
}

struct StorefrontCartLineUpdateInput: Encodable {
    let id: String
    let quantity: Int?
    let attributes: [StorefrontCartAttributeInput]?
}

struct StorefrontCartInput: Encodable {
    let lines: [StorefrontCartLineInput]?
}

// MARK: - Variables

struct StorefrontFetchCartVariables: Encodable {
    let id: String
}

struct StorefrontCreateCartVariables: Encodable {
    let input: StorefrontCartInput?
}

struct StorefrontAddToCartVariables: Encodable {
    let cartId: String
    let lines: [StorefrontCartLineInput]
}

struct StorefrontUpdateCartLinesVariables: Encodable {
    let cartId: String
    let lines: [StorefrontCartLineUpdateInput]
}

struct StorefrontRemoveCartLinesVariables: Encodable {
    let cartId: String
    let lineIds: [String]
}

struct StorefrontUpdateDiscountCodesVariables: Encodable {
    let cartId: String
    let discountCodes: [String]
}

// MARK: - Responses

struct StorefrontFetchCartResponse: Decodable {
    let cart: StorefrontCart?
}

struct StorefrontCartCreateResponse: Decodable {
    let cartCreate: StorefrontCartMutationPayload
}

struct StorefrontCartLinesAddResponse: Decodable {
    let cartLinesAdd: StorefrontCartMutationPayload
}

struct StorefrontCartLinesUpdateResponse: Decodable {
    let cartLinesUpdate: StorefrontCartMutationPayload
}

struct StorefrontCartLinesRemoveResponse: Decodable {
    let cartLinesRemove: StorefrontCartMutationPayload
}

struct StorefrontCartMutationPayload: Decodable {
    let cart: StorefrontCart?
    let userErrors: [StorefrontUserError]
}

struct StorefrontCartDiscountCodesUpdateResponse: Decodable {
    let cartDiscountCodesUpdate: StorefrontCartMutationPayload
}

// MARK: - Models

struct StorefrontCart: Decodable {
    let id: String
    let checkoutUrl: String
    let totalQuantity: Int
    let lines: StorefrontConnection<StorefrontCartLine>
    let discountCodes: [StorefrontCartDiscountCode]
    let cost: StorefrontCartCost
}

struct StorefrontCartLine: Decodable {
    let id: String
    let quantity: Int
    let merchandise: StorefrontCartMerchandise
}

struct StorefrontCartMerchandise: Decodable {
    let id: String
    let title: String
    let price: StorefrontMoney
    let product: StorefrontCartLineProduct
}

struct StorefrontCartLineProduct: Decodable {
    let title: String
    let handle: String
}

struct StorefrontCartCost: Decodable {
    let subtotalAmount: StorefrontMoney
    let totalAmount: StorefrontMoney
    let totalTaxAmount: StorefrontMoney?
}

struct StorefrontCartDiscountCode: Decodable {
    let code: String
    let applicable: Bool
}
