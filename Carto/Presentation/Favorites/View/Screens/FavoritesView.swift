//
//  FavoritesView.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct FavoritesView: View {

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    let products = ProductInfo.mockProducts

    var body: some View {
        VStack(spacing: 0) {
            Text("Favorites")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(products) { product in
                        ProductCard(product: product)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
    }
}
