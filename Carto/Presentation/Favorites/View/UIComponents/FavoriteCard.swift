//
//  FavoriteCard.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct FavoriteCard: View {
    let item: FavoriteItem
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                            }
            
            Image(item.image)
                .resizable()
                .scaledToFit()
                .frame(height: 130)
                .frame(maxWidth: .infinity)
            
            Text(item.title)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
            
            HStack{
                
                Text(item.price)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                Spacer()
                
                ProductColorsView(colors: item.colors)
                
            }
                        
            AddToCartCounter()
            
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}


