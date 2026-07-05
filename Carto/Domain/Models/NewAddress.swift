//
//  NewAddress.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//

import Foundation

struct NewAddress {
    var id: Int = 0
    var address1: String
    var city: String
    var province: String
    var country: String
    var zip: String
    var phone: String
    var firstName: String
    var lastName: String
    var company: String

    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty
            && !lastName.trimmingCharacters(in: .whitespaces).isEmpty
            && !address1.trimmingCharacters(in: .whitespaces).isEmpty
            && !city.trimmingCharacters(in: .whitespaces).isEmpty
            && !country.trimmingCharacters(in: .whitespaces).isEmpty
            && !zip.trimmingCharacters(in: .whitespaces).isEmpty
    }
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
            lastName: lastName,
            company: company
        )
    }
}
