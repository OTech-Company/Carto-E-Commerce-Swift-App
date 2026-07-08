//
//  CartRepository.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

protocol CartRepository {
    func fetchCart() async throws -> CartModel?
    func addLine(variantId: String, quantity: Int) async throws -> CartModel
    func updateLine(lineId: String, quantity: Int) async throws -> CartModel
    func removeLine(lineId: String) async throws -> CartModel
    func applyDiscountCodes(_ codes: [String]) async throws -> CartModel
}
