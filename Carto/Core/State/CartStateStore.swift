//
//  CartStateStore.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Combine
import Foundation

struct SelectedVariant: Equatable {
    var color: String
    var size: String
}

final class CartStateStore: ObservableObject {
    static let shared = CartStateStore()

    @Published private(set) var items: [String: CartItem] = [:]
    @Published private(set) var selectedVariants: [Int: SelectedVariant] = [:]
    @Published var appliedCouponCode: String?
    @Published private(set) var isCouponApplied: Bool = false

    private init() {}

    func initializeCart(_ items: [CartItem]) {
        self.items = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        for item in items {
            selectedVariants[item.productId] = SelectedVariant(color: item.selectedColor, size: item.selectedSize)
        }
    }

    func upsert(_ item: CartItem) {
        items[item.id] = item
        selectedVariants[item.productId] = SelectedVariant(color: item.selectedColor, size: item.selectedSize)
    }

    func remove(id: String) {
        items[id] = nil
    }

    func item(productId: Int, color: String, size: String) -> CartItem? {
        items[CartItem.makeId(productId: productId, color: color, size: size)]
    }

    func items(for productId: Int) -> [CartItem] {
        items.values.filter { $0.productId == productId }
    }

    func selectedVariant(for productId: Int, fallbackColor: String, fallbackSize: String) -> SelectedVariant {
        selectedVariants[productId] ?? SelectedVariant(color: fallbackColor, size: fallbackSize)
    }

    func setSelectedVariant(productId: Int, color: String, size: String) {
        selectedVariants[productId] = SelectedVariant(color: color, size: size)
    }

    var allItems: [CartItem] {
        Array(items.values).sorted { $0.savedAt > $1.savedAt }
    }

    var subtotal: Double {
        allItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }

    var deliveryFee: Double {
        guard !isEmpty else { return 0 }
        return subtotal >= 500 ? 0 : 50
    }

    var discountAmount: Double {
        guard isCouponApplied, let code = appliedCouponCode else { return 0 }
        let percentage: Double
        switch code.lowercased() {
        case "carto10": percentage = 0.10
        case "carto20": percentage = 0.20
        case "carto50": percentage = 0.50
        default: percentage = 0.0
        }
        return subtotal * percentage
    }

    var finalTotal: Double {
        return subtotal + deliveryFee - discountAmount
    }

    var isEmpty: Bool {
        items.isEmpty
    }


    func setCoupon(_ code: String) {
        appliedCouponCode = code
        isCouponApplied = false
    }


    func applyCoupon() {
        guard appliedCouponCode != nil, !(appliedCouponCode?.isEmpty ?? true) else { return }
        isCouponApplied = true
    }


    func clearCoupon() {
        appliedCouponCode = nil
        isCouponApplied = false
    }
}
