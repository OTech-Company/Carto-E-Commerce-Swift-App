//
//  FavoriteCard.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct ProductCard: View {
    @StateObject private var viewModel: ProductCardViewModel
    var onFavoriteTap: (() -> Void)? = nil

    init(product: Product, onFavoriteTap: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeProductCardViewModel(product: product))
        self.onFavoriteTap = onFavoriteTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    onFavoriteTap?() ?? viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
                .buttonStyle(.plain)

                Spacer()
            }

            AsyncImage(url: URL(string: viewModel.product.imageURL)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 115)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(viewModel.product.title)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(3)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("$\(viewModel.product.price, specifier: "%.2f")")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.blue)

                    if let compareAtPrice = viewModel.product.compareAtPrice {
                        Text("$\(compareAtPrice, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }
                }

                if let discount = viewModel.product.discountPercentage {
                    Text("\(discount)% OFF")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.red)
                }
            }

            AddToCartCounter()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}
