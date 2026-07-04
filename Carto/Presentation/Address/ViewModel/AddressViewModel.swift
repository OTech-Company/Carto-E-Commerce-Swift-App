//
//  AddressViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import Combine
import Foundation

@MainActor
class AddressViewModel: ObservableObject {

    @Published var addresses: [Address] = []
    @Published var addressById: Address?
    @Published var addedAddress: Address?
    @Published var updatedAddress: Address?
    @Published var defaultAddress: Address?

    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let repo: AddressRepoProtocol

    init(repo: AddressRepoProtocol) {
        self.repo = repo
    }

    func loadAllAdresses(for customerId: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            addresses = try await repo.getAllAddresses(for: customerId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func getAddressById(_ addressId: String, for customerId: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            addressById = try await repo.getAddressByID(
                addressId,
                for: customerId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addAddress(_ address: NewAddress, for customerId: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            addedAddress = try await repo.addAddress(address, for: customerId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func editAddress(
        for customerId: String,
        addressId: String,
        address: NewAddress
    ) async {
        isLoading = true
        defer {
            isLoading = false
        }

        do {
            updatedAddress = try await repo.updateAddress(
                for: customerId,
                addressID: addressId,
                address: address
            )
        } catch {
            errorMessage = error.localizedDescription
        }

    }

    func deleteAddress(_ addressId: String, for customerId: String) async {
        isLoading = true

        defer {
            isLoading = false
        }

        do {
            try await repo.deleteAddress(addressId, for: customerId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
