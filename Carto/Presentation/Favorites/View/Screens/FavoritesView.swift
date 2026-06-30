//
//  FavoritesView.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct FavoritesView: View {
    let items = [
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        FavoriteItem(image: "shoes", title: "Nike", price: "$37,87", colors: [.cyan, .red]),
        
        
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        VStack {
            Text("Favorites")
                .font(.title3)
                .bold()
                .padding(.top)
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(items) { item in
                        FavoriteCard(item: item)
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGray6))
        
    }
}

