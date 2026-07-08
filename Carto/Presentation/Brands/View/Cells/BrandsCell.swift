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
            Group {
                if let url = brand.image {
                    AsyncImage(url: URL(string: url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 130)
                            .clipped()
                    } placeholder: {
                        Color(.systemGray6)
                            .frame(height: 130)
                            .overlay(ProgressView())
                    }
                } else {
                    Color(.systemGray6)
                        .frame(height: 130)
                        .overlay(
                            Image(systemName: "photo").foregroundColor(.gray)
                        )
                }
            }.clipShape(RoundedRectangle(cornerRadius: 16))

            Text(brand.title)
                .font(.headline)
                .foregroundColor(Color("PrimaryColor"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color("PrimaryColor").opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
//
//#Preview {
//    BrandsCell()
//}
