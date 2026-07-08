//
//  CartRepository.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import Foundation

protocol CartRepository {
    func getCartItems() -> [CartItem]
    func cartItem(productId: Int, color: String, size: String) -> CartItem?
    func addOrUpdate(_ item: CartItem)
    func remove(productId: Int, color: String, size: String)
    func syncFromRemote() async
    func bootstrapStore()
}
