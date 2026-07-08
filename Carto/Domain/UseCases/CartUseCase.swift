//
//  CartUseCase.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

protocol CartUseCaseProtocol {
    func fetchCart() async throws -> CartModel?
    func addToCart(product: Product, color: String, size: String) async throws -> CartModel
    func updateLine(lineId: String, quantity: Int) async throws -> CartModel
    func incrementLine(_ line: CartLine) async throws -> CartModel
    func decrementLine(_ line: CartLine) async throws -> CartModel
    func removeLine(lineId: String) async throws -> CartModel
    func applyDiscount(code: String) async throws -> CartModel
    func removeDiscount() async throws -> CartModel
}

final class CartUseCase: CartUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func fetchCart() async throws -> CartModel? {
        try await repository.fetchCart()
    }

    func addToCart(product: Product, color: String, size: String) async throws -> CartModel {
        guard let variant = product.variantFor(color: color, size: size) else {
            throw CartUseCaseError.variantNotFound
        }
        let variantId = variant.adminGraphqlApiId
            ?? "gid://shopify/ProductVariant/\(variant.id)"

        return try await repository.addLine(variantId: variantId, quantity: 1)
    }

    func updateLine(lineId: String, quantity: Int) async throws -> CartModel {
        if quantity <= 0 {
            return try await repository.removeLine(lineId: lineId)
        }
        return try await repository.updateLine(lineId: lineId, quantity: quantity)
    }

    func incrementLine(_ line: CartLine) async throws -> CartModel {
        try await repository.updateLine(lineId: line.id, quantity: line.quantity + 1)
    }

    func decrementLine(_ line: CartLine) async throws -> CartModel {
        if line.quantity <= 1 {
            return try await repository.removeLine(lineId: line.id)
        }
        return try await repository.updateLine(lineId: line.id, quantity: line.quantity - 1)
    }

    func removeLine(lineId: String) async throws -> CartModel {
        try await repository.removeLine(lineId: lineId)
    }

    func applyDiscount(code: String) async throws -> CartModel {
        try await repository.applyDiscountCodes([code])
    }
    
    func removeDiscount() async throws -> CartModel {
        try await repository.applyDiscountCodes([])
    }
}

enum CartUseCaseError: LocalizedError {
    case variantNotFound

    var errorDescription: String? {
        switch self {
        case .variantNotFound: return "The selected variant was not found for this product."
        }
    }
}
