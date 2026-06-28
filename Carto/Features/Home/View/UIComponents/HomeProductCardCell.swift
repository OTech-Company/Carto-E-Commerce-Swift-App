//
//  HomeProductCardCell.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeProductCardCell: View {
    let product: ProductEntity
    let onTab: () -> Void
    let onAddToFav: () -> Void
    

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(alignment: .bottom){
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(product.rate, specifier: "%.1f")")
                    .font(.system(size: 16))
                    .foregroundColor(Color("PrimaryColor"))
            }
            
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, minHeight: 150)
            HStack {
                VStack(alignment: .leading) {
                    Text(product.name)
                    Text("$\(product.price, specifier: "%.2f")")
                }

                Spacer()

                Button(action: onAddToFav) {
                    Image(systemName: "heart")
                        .font(.system(size: 24))
                        .foregroundStyle(Color("PrimaryColor"))
                }
            }

        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .padding()
        .background(Color("CardBGColor"))
        .cornerRadius(20)
        .shadow(radius: 3)
        .onTapGesture {
            onTab()
        }
    }
}
//
//#Preview {
//    HomeProductCardCell()
//}
