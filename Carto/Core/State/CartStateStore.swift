//
//  CartStateStore.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Combine
import Foundation

final class CartStateStore: ObservableObject {
    static let shared = CartStateStore()

    @Published var cart: CartModel?
    /// Set by the Home banner. CouponSection reads this to pre-fill its text field.
    @Published var suggestedCouponCode: String = ""

    private init() {}

    var isEmpty: Bool {
        cart?.lines.isEmpty ?? true
    }

    var subtotal: Double {
        Double(cart?.subtotal ?? "0") ?? 0
    }

    var total: Double {
        Double(cart?.total ?? "0") ?? 0
    }

    var tax: Double {
        Double(cart?.tax ?? "0") ?? 0
    }
    
    var finalTotal: Double {
        let base = subtotal
        let delivery = deliveryFee
        let disc = discountAmount
        let taxAmount = tax
        return max(0, base + delivery + taxAmount - disc)
    }

    var deliveryFee: Double {
        guard !(cart?.lines.isEmpty ?? true) else { return 0 }
        return subtotal >= 500 ? 0 : 50
    }

    var discountAmount: Double {
        guard let code = cart?.discountCodes.first(where: { $0.isApplicable })?.code else { return 0 }
        let percentage: Double
        switch code.lowercased() {
        case "carto10": percentage = 0.10
        case "carto20": percentage = 0.20
        case "carto50": percentage = 0.50
        default: percentage = 0.0
        }
        return subtotal * percentage
    }

    func setCoupon(_ code: String) {
        suggestedCouponCode = code
    }

    func clearCoupon() {
        suggestedCouponCode = ""
    }
}
