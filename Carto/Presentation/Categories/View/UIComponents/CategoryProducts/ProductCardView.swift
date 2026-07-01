//
//  ProductCardView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//


import SwiftUI

struct ProductCardView: View {

    let product: Product

    var body: some View {

        VStack(alignment: .leading) {

            AsyncImage(url: URL(string: product.mainImageUrl ?? "")) { image in

                image
                    .resizable()
                    .scaledToFit()

            } placeholder: {

                ProgressView()
            }
            .frame(height: 140)

            Text(product.vendor)
                .font(.caption)
                .foregroundColor(.gray)

            Text(product.title)
                .font(.headline)
                .lineLimit(2)

            Text(product.displayPrice)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}