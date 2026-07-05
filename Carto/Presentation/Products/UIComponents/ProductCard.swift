//
//  FavoriteCard.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    @StateObject private var viewModel: ProductCardViewModel
    var onFavoriteTap: (() -> Void)? = nil

    init(product: Product, onFavoriteTap: (() -> Void)? = nil) {
        self.product = product
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeProductCardViewModel(productId: product.id))
        self.onFavoriteTap = onFavoriteTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    onFavoriteTap?() ?? viewModel.toggleFavorite(for: product)
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(viewModel.isFavorite ? .red : .gray)
                }
                .buttonStyle(.plain)

                Spacer()
            }

            imageView
                .frame(height: 115)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(product.title)
                .font(.system(size: 14, weight: .bold))
                .lineLimit(3)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.blue)

                    if let compareAtPrice = product.compareAtPrice {
                        Text("$\(compareAtPrice, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .strikethrough()
                    }
                }

                if let discount = product.discountPercentage {
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

    @ViewBuilder
    private var imageView: some View {
        if let url = URL(string: product.imageURL), !product.imageURL.isEmpty {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    placeholderImage
                case .empty:
                    ProgressView()
                @unknown default:
                    placeholderImage
                }
            }
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .font(.system(size: 28))
            .foregroundColor(.gray.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
