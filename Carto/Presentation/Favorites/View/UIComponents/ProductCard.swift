//
//  FavoriteCard.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct ProductCard: View {
    
    let product: ProductInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                
                Spacer()
            }
            
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 115)
            .frame(maxWidth: .infinity)
            
            Text(product.title)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 2) {
                
                HStack(spacing: 6) {
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.blue)
                    
                    if let compareAtPrice = product.compareAtPrice {
                        Text("$\(compareAtPrice, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }
                }
                
                
                if let discount = product.discountPercentage {
                    Text("\(discount)% OFF")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.red)
                }
            }
            
            AddToCartCounter()
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
