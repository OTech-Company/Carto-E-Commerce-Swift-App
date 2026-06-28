//
//  ProductEntity.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//
import SwiftUI

struct ProductEntity: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let rate: Double
}
