//
//  NewAddress.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

struct NewAddress {
    let address1: String
    let city: String
    let province: String
    let country: String
    let zip: String
    let phone: String
    let firstName: String
    let lastName: String
}

extension NewAddress {
    func toRequestDTO() -> AddressRequestDTO {
        AddressRequestDTO(
            address1: address1,
            city: city,
            province: province,
            country: country,
            zip: zip,
            phone: phone,
            firstName: firstName,
            lastName: lastName
        )
    }
}
