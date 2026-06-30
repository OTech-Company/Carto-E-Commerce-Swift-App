//
//  ProductColorsView.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct FavoriteItem: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let price: String
    let colors: [Color]
    
}

struct ProductColorsView: View {
    let colors: [Color]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(colors.indices, id: \.self) {
                index in
                Circle()
                    .fill(colors[index])
                    .frame(width: 12, height: 12)
            }
        }
    }
}


