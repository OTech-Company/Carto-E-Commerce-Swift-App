//
//  PaymentMethod.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case paymob
    case cashOnDelivery

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .paymob: return "Card / Wallet"
        case .cashOnDelivery: return "Cash on Delivery"
        }
    }

    var subtitle: String {
        switch self {
        case .paymob: return "Visa, Mastercard, mobile wallets via Paymob"
        case .cashOnDelivery: return "Pay when your order arrives"
        }
    }

    var iconName: String {
        switch self {
        case .paymob: return "creditcard.fill"
        case .cashOnDelivery: return "banknote.fill"
        }
    }

    var gatewayName: String {
        switch self {
        case .paymob: return "Paymob"
        case .cashOnDelivery: return "Cash on Delivery"
        }
    }
}
