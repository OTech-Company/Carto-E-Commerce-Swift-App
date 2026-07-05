//
//  AddressDTO.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//
import Foundation

struct AddressRequestDTO: Encodable {
    let address1: String
    let city: String
    let province: String
    let country: String
    let zip: String
    let phone: String
    let firstName: String
    let lastName: String
    let company: String

    enum CodingKeys: String, CodingKey {
        case address1
        case city
        case province
        case country
        case zip
        case phone
        case firstName = "first_name"
        case lastName = "last_name"
        case company
    }
}

struct AddressResponseDTO: Decodable {
    let addresses: [AddressDTO]
}

struct AddressByIdDTO: Decodable {
    let customerAddress: AddressDTO
}

struct AddressDTO: Decodable {
    let id: Int
    let customerId: Int
    let company: String?
    let province: String
    let country: String
    let provinceCode: String
    let countryCode: String
    let countryName: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerId
        case company
        case province
        case country
        case provinceCode
        case countryCode
        case countryName
        case isDefault = "default"
    }
}

extension AddressDTO {
    func toDomain() -> CustomerAddress {
        return CustomerAddress(
            id: String(id),
            address1: "",
            address2: "",
            city: "",
            province: province,
            country: country,
            zip: ""
        )
    }
}

struct EmptyResponse: Decodable {}
