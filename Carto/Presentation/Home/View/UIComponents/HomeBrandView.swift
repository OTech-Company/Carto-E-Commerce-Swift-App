//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI

struct HomeBrandView: View {
    let barndLogo: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 120, height: 120)
                .shadow(radius: 5)

            Image(barndLogo)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("PrimaryColor"), lineWidth: 3)
                )
        }
    }
}

#Preview {
    HomeBrandView(barndLogo: "Green 1")
}
