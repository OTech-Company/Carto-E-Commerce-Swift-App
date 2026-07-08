//
//  ProductMiniCard.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI

struct ProductMiniCard: View {
    let product: Product?
    
    var body: some View {
        HStack(spacing: 12) {
            if let urlString = product?.mainImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(product?.title ?? "Product Reference")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Text(product?.vendor ?? "Vendor")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

