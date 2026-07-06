//
//  ComparisonInputField.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI

struct ComparisonInputField: View {
    let title: String
    @Binding var query: String
    let selectedProduct: Product?
    let recommendations: [Product]
    let onSelect: (Product) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField(title, text: $query)
                    .font(.subheadline)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .background(Color(.systemGray6).opacity(0.6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Spacer()
                            if selectedProduct != nil {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .padding(.trailing, 14)
                            }
                        }
                    )
            }
            
            if !recommendations.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(recommendations.prefix(3)) { product in
                        Button(action: { onSelect(product) }) {
                            HStack(spacing: 12) {
                                if let urlString = product.mainImageUrl, let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 36, height: 36)
                                    .cornerRadius(6)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(product.title)
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                    Text(product.vendor)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                        }
                        Divider().padding(.horizontal, 14)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            }
        }
    }
}

