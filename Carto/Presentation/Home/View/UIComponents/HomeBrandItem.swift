//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI

struct HomeBrandItem: View {
    let barndLogo: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 100, height: 100)
                .shadow(radius: 5)

            AsyncImage(url: URL(string: barndLogo)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color("PrimaryColor"), lineWidth: 3)
            )
        }
    }
}
