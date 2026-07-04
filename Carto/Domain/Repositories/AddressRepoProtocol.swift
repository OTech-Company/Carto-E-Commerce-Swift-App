//
//  AddressRepoProtocol.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

protocol AddressRepoProtocol {
    func getAllAddresses(for customerID: String) async throws -> [Address]
    
    func getAddressByID(_ addressId: String, for customerID: String) async throws
        -> Address
    
    func addAddress(_ address: NewAddress, for customerID: String)
        async throws -> Address
    
    func updateAddress(
        for customerID: String,
        addressID: String,
        address: NewAddress
    ) async throws -> Address
    
    func setDefaultAddress(addressID: String, for customerID: String)
        async throws -> Address
    
    func deleteAddress(_ addressID: String, for customerID: String) async throws
}
