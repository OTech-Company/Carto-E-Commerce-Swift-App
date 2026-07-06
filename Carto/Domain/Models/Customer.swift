//
//  Customer.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

struct Customer {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let defaultAddress: CustomerAddress?
    let addresses: [CustomerAddress]
    let orders: [CustomerOrder]
}

struct CustomerOrderLineItem {
    let title: String
    let quantity: Int
}

struct CustomerAuthToken {
    let accessToken: String
    let expiresAt: String
}
