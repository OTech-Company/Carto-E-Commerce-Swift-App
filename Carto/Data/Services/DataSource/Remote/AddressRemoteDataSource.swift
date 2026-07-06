//
//  AddressRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

protocol AddressRemoteDataSource {
    func createAddress(accessToken: String, address: StorefrontMailingAddressInput) async throws -> CustomerAddress
    func updateAddress(accessToken: String, id: String, address: StorefrontMailingAddressInput) async throws -> CustomerAddress
    func deleteAddress(accessToken: String, id: String) async throws -> String
    func setDefaultAddress(accessToken: String, addressId: String) async throws -> CustomerAddress?
}

final class AddressGraphQLRemoteDataSource: AddressRemoteDataSource {

    private let client: GraphQLClient

    init(client: GraphQLClient = GraphQLStorefrontClient.shared) {
        self.client = client
    }

    func createAddress(accessToken: String, address: StorefrontMailingAddressInput) async throws -> CustomerAddress {
        let request = GraphQLRequest(
            query: StorefrontAddressQueries.createAddress,
            variables: StorefrontCreateAddressVariables(customerAccessToken: accessToken, address: address),
            operationName: "CustomerAddressCreate"
        )
        let response: StorefrontCreateAddressResponse = try await client.request(request)
        return try response.customerAddressCreate.toDomain()
    }

    func updateAddress(accessToken: String, id: String, address: StorefrontMailingAddressInput) async throws -> CustomerAddress {
        let request = GraphQLRequest(
            query: StorefrontAddressQueries.updateAddress,
            variables: StorefrontUpdateAddressVariables(customerAccessToken: accessToken, id: id, address: address),
            operationName: "CustomerAddressUpdate"
        )
        let response: StorefrontUpdateAddressResponse = try await client.request(request)
        return try response.customerAddressUpdate.toDomain()
    }

    func deleteAddress(accessToken: String, id: String) async throws -> String {
        let request = GraphQLRequest(
            query: StorefrontAddressQueries.deleteAddress,
            variables: StorefrontDeleteAddressVariables(customerAccessToken: accessToken, id: id),
            operationName: "CustomerAddressDelete"
        )
        let response: StorefrontDeleteAddressResponse = try await client.request(request)
        return try response.customerAddressDelete.toDomain()
    }

    func setDefaultAddress(accessToken: String, addressId: String) async throws -> CustomerAddress? {
        let request = GraphQLRequest(
            query: StorefrontAddressQueries.setDefaultAddress,
            variables: StorefrontSetDefaultAddressVariables(customerAccessToken: accessToken, addressId: addressId),
            operationName: "CustomerDefaultAddressUpdate"
        )
        let response: StorefrontSetDefaultAddressResponse = try await client.request(request)
        return try response.customerDefaultAddressUpdate.toDomain()
    }
}
