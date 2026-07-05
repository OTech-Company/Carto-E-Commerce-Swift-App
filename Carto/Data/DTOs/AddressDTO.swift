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
    func toDomain() -> Address {
        return Address(
            id: id,
            customerId: customerId,
            company: company,
            province: province,
            country: country,
            provinceCode: provinceCode,
            countryCode: countryCode,
            countryName: countryName,
            isDefault: isDefault
        )
    }
}

struct EmptyResponse: Decodable {}
