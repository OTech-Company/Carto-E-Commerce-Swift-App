//
//  StorefrontAddressMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontAddressError: LocalizedError {
    case userErrors([String])

    var errorDescription: String? {
        switch self {
        case .userErrors(let messages): return messages.joined(separator: "\n")
        }
    }
}

extension StorefrontAddressMutationPayload {
    func toDomain() throws -> CustomerAddress {
        guard customerUserErrors.isEmpty else {
            throw StorefrontAddressError.userErrors(customerUserErrors.map { $0.message })
        }
        guard let address = customerAddress else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    StorefrontAddress.self,
                    .init(codingPath: [], debugDescription: "Address mutation returned no address")
                )
            )
        }
        return address.toDomain()
    }
}

extension StorefrontDeleteAddressPayload {
    func toDomain() throws -> String {
        guard customerUserErrors.isEmpty else {
            throw StorefrontAddressError.userErrors(customerUserErrors.map { $0.message })
        }
        guard let deletedId = deletedCustomerAddressId else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    String.self,
                    .init(codingPath: [], debugDescription: "Address delete returned no id")
                )
            )
        }
        return deletedId
    }
}

extension StorefrontSetDefaultAddressPayload {
    func toDomain() throws -> CustomerAddress? {
        guard customerUserErrors.isEmpty else {
            throw StorefrontAddressError.userErrors(customerUserErrors.map { $0.message })
        }
        return customer?.defaultAddress?.toDomain()
    }
}

struct CustomerAddressPage {
    let items: [CustomerAddress]
    let hasNextPage: Bool
    let endCursor: String?
    let defaultAddressId: String?
}
