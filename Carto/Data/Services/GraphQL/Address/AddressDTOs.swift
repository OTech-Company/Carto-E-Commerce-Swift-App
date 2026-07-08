//
//  AddressDTOs.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

// MARK: - Inputs

struct StorefrontMailingAddressInput: Encodable {
    let address1: String?
    let address2: String?
    let city: String?
    let country: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let province: String?
    let zip: String?
}

// MARK: - Variables

struct StorefrontFetchAddressesVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
}

struct StorefrontCreateAddressVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
    let address: StorefrontMailingAddressInput
}

struct StorefrontUpdateAddressVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
    let id: String
    let address: StorefrontMailingAddressInput
}

struct StorefrontDeleteAddressVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
    let id: String
}

struct StorefrontSetDefaultAddressVariables: Encodable {
    var country: String = AppSettings.shared.currentCountryCode
    var language: String = AppSettings.shared.currentLanguageCode
    let customerAccessToken: String
    let addressId: String
}

// MARK: - Responses

struct StorefrontFetchAddressesResponse: Decodable {
    let customer: StorefrontFetchAddressesCustomer?
}

struct StorefrontFetchAddressesCustomer: Decodable {
    let defaultAddress: StorefrontDefaultAddressId?
    let addresses: StorefrontConnection<StorefrontAddress>
}

struct StorefrontDefaultAddressId: Decodable {
    let id: String
}

struct StorefrontCreateAddressResponse: Decodable {
    let customerAddressCreate: StorefrontAddressMutationPayload
}

struct StorefrontUpdateAddressResponse: Decodable {
    let customerAddressUpdate: StorefrontAddressMutationPayload
}

struct StorefrontDeleteAddressResponse: Decodable {
    let customerAddressDelete: StorefrontDeleteAddressPayload
}

struct StorefrontSetDefaultAddressResponse: Decodable {
    let customerDefaultAddressUpdate: StorefrontSetDefaultAddressPayload
}

struct StorefrontAddressMutationPayload: Decodable {
    let customerAddress: StorefrontAddress?
    let customerUserErrors: [StorefrontUserError]
}

struct StorefrontDeleteAddressPayload: Decodable {
    let deletedCustomerAddressId: String?
    let customerUserErrors: [StorefrontUserError]
}

struct StorefrontSetDefaultAddressPayload: Decodable {
    let customer: StorefrontDefaultAddressCustomer?
    let customerUserErrors: [StorefrontUserError]
}

struct StorefrontDefaultAddressCustomer: Decodable {
    let id: String
    let defaultAddress: StorefrontAddress?
}
