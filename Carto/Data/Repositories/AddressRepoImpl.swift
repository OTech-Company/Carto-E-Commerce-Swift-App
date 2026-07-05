//
//  AddressRepoImpl.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

class AddressRepoImpl: AddressRepoProtocol {

    private let remoteDataSource: AddressRemoteDataSource

    init(remoteDataSource: AddressRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getAllAddresses(for customerID: String) async throws
        -> [CustomerAddress]
    {
        return try await remoteDataSource.fetchAddresses(
            accessToken: customerID
        )
    }

    func getAddressByID(_ addressId: String, for customerID: String)
        async throws -> CustomerAddress
    {
        let addresses = try await remoteDataSource.fetchAddresses(
            accessToken: customerID
        )
        guard let address = addresses.first(where: { $0.id == addressId })
        else {
            throw NSError(
                domain: "AddressRepo",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Address not found"]
            )
        }
        return address
    }

    func addAddress(_ address: CustomerAddress, for customerID: String)
        async throws
        -> CustomerAddress
    {
        return try await remoteDataSource.createAddress(
            accessToken: customerID,
            address: address.toMailingAddressInput()
        )
    }

    func updateAddress(
        for customerID: String,
        addressID: String,
        address: CustomerAddress
    ) async throws -> CustomerAddress {
        return try await remoteDataSource.updateAddress(
            accessToken: customerID,
            id: addressID,
            address: address.toMailingAddressInput()
        )
    }

    func setDefaultAddress(addressID: String, for customerID: String)
        async throws -> CustomerAddress
    {
        guard
            let address = try await remoteDataSource.setDefaultAddress(
                accessToken: customerID,
                addressId: addressID
            )
        else {
            throw NSError(
                domain: "AddressRepo",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey: "Default address not found"
                ]
            )
        }
        return address
    }

    func deleteAddress(_ addressID: String, for customerID: String) async throws
    {
        _ = try await remoteDataSource.deleteAddress(
            accessToken: customerID,
            id: addressID
        )
    }
}
