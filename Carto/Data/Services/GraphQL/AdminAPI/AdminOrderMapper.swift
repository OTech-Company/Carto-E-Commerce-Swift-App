//
//  AdminOrderMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct AdminOrder {
    let id: String
    let orderName: String
    let createdAt: String
    let financialStatus: String
    let total: String
    let currencyCode: String
}

enum AdminOrderError: LocalizedError {
    case userErrors([String])

    var errorDescription: String? {
        switch self {
        case .userErrors(let messages): return messages.joined(separator: "\n")
        }
    }
}

extension AdminOrderDTO {
    func toDomain() -> AdminOrder {
        AdminOrder(
            id: id,
            orderName: name,
            createdAt: createdAt,
            financialStatus: displayFinancialStatus ?? "",
            total: totalPriceSet.shopMoney.amount,
            currencyCode: totalPriceSet.shopMoney.currencyCode
        )
    }
}

extension AdminOrderCreatePayload {
    func toDomain() throws -> AdminOrder {
        guard userErrors.isEmpty else {
            throw AdminOrderError.userErrors(userErrors.map { $0.message })
        }
        guard let order else {
            throw AdminAPIError.decodingFailed("orderCreate returned no order")
        }
        return order.toDomain()
    }
}
