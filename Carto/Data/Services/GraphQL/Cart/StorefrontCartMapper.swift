//
//  StorefrontCartMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontCartError: LocalizedError {
    case userErrors([String])

    var errorDescription: String? {
        switch self {
        case .userErrors(let messages): return messages.joined(separator: "\n")
        }
    }
}

extension StorefrontCart {
    func toDomain() -> CartModel {
        CartModel(
            id: id,
            checkoutURL: checkoutUrl,
            totalQuantity: totalQuantity,
            lines: lines.nodes.map { $0.toDomain() },
            discountCodes: discountCodes.map { $0.toDomain() },
            subtotal: cost.subtotalAmount.amount,
            total: cost.totalAmount.amount,
            tax: cost.totalTaxAmount?.amount,
            currencyCode: cost.totalAmount.currencyCode
        )
    }
}

extension StorefrontCartDiscountCode {
    func toDomain() -> CartDiscountCode {
        CartDiscountCode(code: code, isApplicable: applicable)
    }
}

extension StorefrontCartLine {
    func toDomain() -> CartLine {
        CartLine(
            id: id,
            variantId: merchandise.id,
            productTitle: merchandise.product.title,
            variantTitle: merchandise.title,
            quantity: quantity,
            price: merchandise.price.amount
        )
    }
}

extension StorefrontCartMutationPayload {
    func toDomain() throws -> CartModel {
        guard userErrors.isEmpty else {
            throw StorefrontCartError.userErrors(userErrors.map { $0.message })
        }
        guard let cart else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    StorefrontCart.self,
                    .init(codingPath: [], debugDescription: "Cart mutation returned no cart")
                )
            )
        }
        return cart.toDomain()
    }
}


