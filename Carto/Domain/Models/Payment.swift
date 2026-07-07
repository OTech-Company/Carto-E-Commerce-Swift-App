//
//  Payment.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation

// MARK: - Buyer Identity

struct CheckoutBuyerIdentity {
    let email: String?
    let phone: String?
    let countryCode: String?
    let deliveryAddress: CustomerAddress?

    init(
        email: String? = nil,
        phone: String? = nil,
        countryCode: String? = nil,
        deliveryAddress: CustomerAddress? = nil
    ) {
        self.email = email
        self.phone = phone
        self.countryCode = countryCode
        self.deliveryAddress = deliveryAddress
    }
}

// MARK: - Payment Method

enum PaymentMethodOption: String, CaseIterable, Identifiable {
    case shopifyCheckout
    case cashOnDelivery

    var id: String { rawValue }

    var title: String {
        switch self {
        case .shopifyCheckout: return "Card, Apple Pay & Shop Pay"
        case .cashOnDelivery: return "Cash on Delivery"
        }
    }

    var subtitle: String {
        switch self {
        case .shopifyCheckout: return "Pay securely through Shopify's encrypted checkout"
        case .cashOnDelivery: return "Pay with cash when your order arrives"
        }
    }

    var iconName: String {
        switch self {
        case .shopifyCheckout: return "creditcard.fill"
        case .cashOnDelivery: return "banknote.fill"
        }
    }

    /// Whether this option requires launching the Shopify-hosted web checkout.
    var requiresWebCheckout: Bool {
        self == .shopifyCheckout
    }
}

// MARK: - Checkout Session

/// Represents an in-flight handoff to Shopify's hosted checkout for a cart.
struct CheckoutSession: Equatable {
    let cartId: String
    let checkoutURL: URL
    let totalAmount: String
    let currencyCode: String
}

// MARK: - Checkout Redirect Result

/// The outcome inferred from observing navigation inside the checkout web view.
enum CheckoutCompletionResult: Equatable {
    case success(orderReference: String?)
    case cancelled
    case failed(String)
}

// MARK: - Order Confirmation

struct OrderConfirmationSummary {
    let orderReference: String
    let items: [CartLine]
    let subtotalDisplay: String
    let shippingDisplay: String
    let taxDisplay: String?
    let totalDisplay: String
    let currencyCode: String
    let paymentMethod: PaymentMethodOption
}

// MARK: - Errors

enum PaymentError: LocalizedError, Equatable {
    case emptyCart
    case missingShippingAddress
    case invalidCheckoutURL

    var errorDescription: String? {
        switch self {
        case .emptyCart:
            return "Your cart is empty, so there's nothing to check out."
        case .missingShippingAddress:
            return "Please add a shipping address before continuing."
        case .invalidCheckoutURL:
            return "We couldn't prepare a secure checkout link. Please try again."
        }
    }
}
