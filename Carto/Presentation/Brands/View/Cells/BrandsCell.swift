//
//  BrandsCell.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct BrandsCell: View {
    let brand: BrandEntity

    var body: some View {
        VStack(spacing: 12) {
            CircularNetworkImag(imagURL: brand.image ?? "")

            Text(brand.title)
                .font(.headline)
                .foregroundColor(Color("PrimaryColor"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color("CardBGColor"))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
//
//#Preview {
//    BrandsCell()
//}
