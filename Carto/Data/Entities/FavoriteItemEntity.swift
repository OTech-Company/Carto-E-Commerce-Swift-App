//
//  FavoriteItemEntity.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import Foundation

struct FavoriteItemEntity: Identifiable, Equatable {
    let id: Int
    let product: Product
    let savedAt: Date
}
