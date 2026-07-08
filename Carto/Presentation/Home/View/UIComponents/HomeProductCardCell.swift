//
//  HomeProductCardCell.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeProductCardCell: View {
    let product: Product
    let onTab: () -> Void
    let onAddToFav: () -> Void
    
    @AppStorage("app_currency") var appCurrency: AppCurrency = .egyptianPound
    

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
//            HStack(alignment: .bottom){
//                Spacer()
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//                Text("\(product.rate, specifier: "%.1f")")
//                    .font(.system(size: 16))
//                    .foregroundColor(Color("PrimaryColor"))
//            }
            
            Image(product.imageURL)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, minHeight: 150)
            HStack {
                VStack(alignment: .leading) {
                    Text(product.handle)
                    Text(appCurrency.format(price: product.price))
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
        .shadow(color: Color("PrimaryColor").opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTab()
        }
    }
}
//
//#Preview {
//    HomeProductCardCell()
//}
