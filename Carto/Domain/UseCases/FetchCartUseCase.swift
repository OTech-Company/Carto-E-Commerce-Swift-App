//
//  File.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation

// MARK: - Fetch Cart

protocol FetchCartUseCase {
    func execute(cartId: String) async throws -> CartModel?
}

struct FetchCartUseCaseImpl: FetchCartUseCase {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute(cartId: String) async throws -> CartModel? {
        try await repository.fetchCart(id: cartId)
    }
}

// MARK: - Prepare Checkout

protocol PrepareCheckoutUseCase {
    func execute(cart: CartModel, buyerIdentity: CheckoutBuyerIdentity) async throws -> CheckoutSession
}

struct PrepareCheckoutUseCaseImpl: PrepareCheckoutUseCase {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute(cart: CartModel, buyerIdentity: CheckoutBuyerIdentity) async throws -> CheckoutSession {
        try await repository.prepareCheckout(cart: cart, buyerIdentity: buyerIdentity)
    }
}

// MARK: - Apply Discount Code

protocol ApplyDiscountCodeUseCase {
    func execute(cartId: String, code: String) async throws -> CartModel
}

struct ApplyDiscountCodeUseCaseImpl: ApplyDiscountCodeUseCase {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute(cartId: String, code: String) async throws -> CartModel {
        try await repository.applyDiscountCode(cartId: cartId, code: code)
    }
}

// MARK: - Fetch Order Confirmation

protocol FetchOrderConfirmationUseCase {
    func execute(orderId: String) async throws -> CustomerOrderDetail?
}

struct FetchOrderConfirmationUseCaseImpl: FetchOrderConfirmationUseCase {
    private let repository: PaymentRepository

    init(repository: PaymentRepository = PaymentRepositoryImpl()) {
        self.repository = repository
    }

    func execute(orderId: String) async throws -> CustomerOrderDetail? {
        try await repository.fetchOrderConfirmation(orderId: orderId)
    }
}
