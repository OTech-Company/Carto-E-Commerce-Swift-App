//
//  HomeBannerView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeBannerView: View {
    let ad: ADEntity

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBGColor"))
                .frame(height: 170)

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(ad.title)
                        .font(.system(size: 28, weight: .bold))

                    Text(ad.description)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .padding(.leading, 24)

                Spacer()

            }
            Image(ad.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .offset(x: 100, y: 0)
        }
    }
}

//#Preview {
//    HomeBannerView()
//}
