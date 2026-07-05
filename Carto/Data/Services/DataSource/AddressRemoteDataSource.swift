//
//  AddressRemoteDataSource.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//
import Foundation

protocol AddressRemoteDataSourceProtocol {
    func getAllAddresses(for customerID: String) async throws -> AddressResponseDTO
    func getAddressByID(for addressID: String, customerID: String) async throws -> AddressByIdDTO
    func addAddress(for customerID: String, address: AddressRequestDTO) async throws -> AddressByIdDTO
    func updateAddress(for addressID: String, customerID: String, address: AddressRequestDTO) async throws -> AddressByIdDTO
    func setDefaultAddress(for customerID: String, addressID: String) async throws -> AddressByIdDTO
    func deleteAddress(for addressID: String, customerID: String) async throws -> Void
}

class AddressRemoteDataSource: AddressRemoteDataSourceProtocol {
    func getAllAddresses(for customerID: String) async throws
        -> AddressResponseDTO
    {
        let response: AddressResponseDTO = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.addresses(customerId: customerID)
            )
        return response
    }

    func getAddressByID(for addressID: String, customerID: String) async throws
        -> AddressByIdDTO
    {
        let response: AddressByIdDTO = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.addressByID(
                    id: addressID,
                    customerId: customerID
                )
            )
        return response
    }

    func addAddress(for customerID: String, address: AddressRequestDTO)
        async throws -> AddressByIdDTO
    {
        let response: AddressByIdDTO = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.addAddress(
                    customerId: customerID
                ),
                body: ["address": address]
            )
        return response
    }

    func updateAddress(
        for addressID: String,
        customerID: String,
        address: AddressRequestDTO
    ) async throws -> AddressByIdDTO {
        let response: AddressByIdDTO = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.updateAddress(
                    id: addressID,
                    customerId: customerID
                ),
                body: ["address": address]
            )
        return response
    }

    func setDefaultAddress(for customerID: String, addressID: String)
        async throws -> AddressByIdDTO
    {
        let response: AddressByIdDTO = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.setDefaultAddress(
                    customerId: customerID,
                    addressId: addressID
                )
            )
        return response
    }

    func deleteAddress(for addressID: String, customerID: String) async throws {
        let response: EmptyResponse = try await ShopifyAPIClient.shared
            .requestREST(
                endpoint: ShopifyEndpoint.deleteAddress(
                    id: addressID,
                    customerId: customerID
                )
            )
    }
}
