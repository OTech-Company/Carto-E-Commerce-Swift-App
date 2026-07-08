//
//  Address.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct CustomerAddress: Identifiable, Hashable {
    var id: String
    var address1: String
    var address2: String?
    var city: String
    var province: String
    var country: String
    var zip: String
    var phone: String
    var firstName: String
    var lastName: String
    var company: String?
    var isDefault: Bool

    init(
        id: String = "",
        address1: String = "",
        address2: String? = nil,
        city: String = "",
        province: String = "",
        country: String = "",
        zip: String = "",
        phone: String = "",
        firstName: String = "",
        lastName: String = "",
        company: String? = nil,
        isDefault: Bool = false
    ) {
        self.id = id
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.province = province
        self.country = country
        self.zip = zip
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.isDefault = isDefault
    }

    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty
            && !lastName.trimmingCharacters(in: .whitespaces).isEmpty
            && !address1.trimmingCharacters(in: .whitespaces).isEmpty
            && !city.trimmingCharacters(in: .whitespaces).isEmpty
            && !country.trimmingCharacters(in: .whitespaces).isEmpty
            && !zip.trimmingCharacters(in: .whitespaces).isEmpty
            && !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension CustomerAddress {
    func toMailingAddressInput() -> StorefrontMailingAddressInput {
        StorefrontMailingAddressInput(
            address1: address1,
            address2: address2,
            city: city,
            country: country,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            province: province,
            zip: zip
        )
    }
}
