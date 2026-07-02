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

            CircularNetworkImag(imagURL: barndLogo)
                .overlay(
                    Circle()
                        .stroke(Color("PrimaryColor"), lineWidth: 3)
                )
        }
    }
}
