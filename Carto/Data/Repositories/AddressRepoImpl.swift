//
//  AddressRepoImpl.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

class AddressRepoImpl: AddressRepoProtocol {

    private let remoteDataSource: AddressRemoteDataSourceProtocol

    init(remoteDataSource: AddressRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getAllAddresses(for customerID: String) async throws -> [Address] {
        let response = try await remoteDataSource.getAllAddresses(
            for: customerID
        )
        return response.addresses.map { $0.toDomain() }
    }

    func getAddressByID(_ addressId: String, for customerID: String)
        async throws -> Address
    {
        let response = try await remoteDataSource.getAddressByID(
            for: addressId,
            customerID: customerID
        )
        return response.customerAddress.toDomain()
    }

    func addAddress(_ address: NewAddress, for customerID: String) async throws
        -> Address
    {
        let response = try await remoteDataSource.addAddress(
            for: customerID,
            address: address.toRequestDTO()
        )
        return response.customerAddress.toDomain()
    }

    func updateAddress(
        for customerID: String,
        addressID: String,
        address: NewAddress
    ) async throws -> Address {
        let response = try await remoteDataSource.updateAddress(
            for: addressID,
            customerID: customerID,
            address: address.toRequestDTO()
        )
        return response.customerAddress.toDomain()
    }

    func setDefaultAddress(addressID: String, for customerID: String)
        async throws -> Address
    {
        let response = try await remoteDataSource.setDefaultAddress(
            for: customerID,
            addressID: addressID
        )
        return response.customerAddress.toDomain()
    }

    func deleteAddress(_ addressID: String, for customerID: String) async throws
    {
        try await remoteDataSource.deleteAddress(
            for: addressID,
            customerID: customerID
        )
    }
}
