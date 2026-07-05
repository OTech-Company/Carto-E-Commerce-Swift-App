//
//  Address.swift
//  Carto
//
//  Created by Nadin Ahmed on 04/07/2026.
//
import Foundation

struct Address: Identifiable {
    let id: Int
    let customerId: Int
    let company: String?
    let province: String
    let country: String
    let provinceCode: String
    let countryCode: String
    let countryName: String
    let isDefault: Bool
}

extension Address {
    func toNewAddress() -> NewAddress {
        NewAddress(
            id: id,
            address1: "",
            city: countryName,
            province: province,
            country: country,
            zip: "",
            phone: "",
            firstName: "",
            lastName: "",
            company: company ?? ""
        )
    }
}
