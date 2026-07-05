//
//  AddressRepoProtocol.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

protocol AddressRepoProtocol {
    func getAllAddresses(for customerID: String) async throws -> [CustomerAddress]
    
    func getAddressByID(_ addressId: String, for customerID: String) async throws
        -> CustomerAddress
    
    func addAddress(_ address: CustomerAddress, for customerID: String)
        async throws -> CustomerAddress
    
    func updateAddress(
        for customerID: String,
        addressID: String,
        address: CustomerAddress
    ) async throws -> CustomerAddress
    
    func setDefaultAddress(addressID: String, for customerID: String)
        async throws -> CustomerAddress
    
    func deleteAddress(_ addressID: String, for customerID: String) async throws
}
