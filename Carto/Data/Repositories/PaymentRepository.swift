//
//  a.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation

protocol PaymentRepository {
    func fetchCart(id: String) async throws -> CartModel?

    func prepareCheckout(cart: CartModel, buyerIdentity: CheckoutBuyerIdentity) async throws -> CheckoutSession

    func applyDiscountCode(cartId: String, code: String) async throws -> CartModel

    func fetchOrderConfirmation(orderId: String) async throws -> CustomerOrderDetail?
}

final class PaymentRepositoryImpl: PaymentRepository {

    private let cartDataSource: CartRemoteDataSource
    private let orderDataSource: OrderRemoteDataSource

    init(
        cartDataSource: CartRemoteDataSource = CartGraphQLRemoteDataSource(),
        orderDataSource: OrderRemoteDataSource = OrderGraphQLRemoteDataSource()
    ) {
        self.cartDataSource = cartDataSource
        self.orderDataSource = orderDataSource
    }

    func fetchCart(id: String) async throws -> CartModel? {
        try await cartDataSource.fetchCart(id: id)
    }

    func prepareCheckout(cart: CartModel, buyerIdentity: CheckoutBuyerIdentity) async throws -> CheckoutSession {
        guard !cart.lines.isEmpty else {
            throw PaymentError.emptyCart
        }

        let deliveryAddressPreferences = buyerIdentity.deliveryAddress.map { address in
            [
                StorefrontCartDeliveryAddressPreferenceInput(
                    deliveryAddress: StorefrontMailingAddressInput(
                        address1: address.address1,
                        address2: address.address2,
                        city: address.city,
                        country: address.country,
                        firstName: nil,
                        lastName: nil,
                        phone: buyerIdentity.phone,
                        province: address.province,
                        zip: address.zip
                    )
                )
            ]
        }

        let input = StorefrontCartBuyerIdentityInput(
            email: buyerIdentity.email,
            phone: buyerIdentity.phone,
            countryCode: buyerIdentity.countryCode,
            deliveryAddressPreferences: deliveryAddressPreferences
        )

        let updatedCart = try await cartDataSource.updateBuyerIdentity(cartId: cart.id, buyerIdentity: input)

        guard let checkoutURL = URL(string: updatedCart.checkoutURL) else {
            throw PaymentError.invalidCheckoutURL
        }

        return CheckoutSession(
            cartId: updatedCart.id,
            checkoutURL: checkoutURL,
            totalAmount: updatedCart.total,
            currencyCode: updatedCart.currencyCode
        )
    }

    func applyDiscountCode(cartId: String, code: String) async throws -> CartModel {
        try await cartDataSource.updateDiscountCodes(cartId: cartId, discountCodes: [code])
    }

    func fetchOrderConfirmation(orderId: String) async throws -> CustomerOrderDetail? {
        try await orderDataSource.fetchOrderDetail(id: orderId)
    }
}
