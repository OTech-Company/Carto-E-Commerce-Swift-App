//
//  ProductCard.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

private final class ProductImageCache {
    static let shared = ProductImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 200
        cache.totalCostLimit = 100 * 1024 * 1024 
    }

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func store(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * image.scale * image.scale)
        cache.setObject(image, forKey: url.absoluteString as NSString, cost: cost)
    }
}

private final class CachedImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var failed = false

    private var task: URLSessionDataTask?

    func load(url: URL) {
        if let cached = ProductImageCache.shared.image(for: url) {
            self.image = cached
            return
        }

        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }
            if let urlError = error as? URLError, urlError.code == .cancelled { return }
            guard let data, let loaded = UIImage(data: data) else {
                DispatchQueue.main.async { self.failed = true }
                return
            }
            ProductImageCache.shared.store(loaded, for: url)
            DispatchQueue.main.async { self.image = loaded }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}

private struct CachedProductImage: View {
    let url: URL
    @StateObject private var loader = CachedImageLoader()

    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
            } else if loader.failed {
                placeholderImage
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear { loader.load(url: url) }
        .onDisappear { loader.cancel() }
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .font(.system(size: 28))
            .foregroundColor(.gray.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProductCard: View {
    let product: Product
    @StateObject private var viewModel: ProductCardViewModel
    var onFavoriteTap: (() -> Void)? = nil

    @State private var appeared = false
    @State private var favBounce = false
    @State private var isPressed = false

    init(product: Product, onFavoriteTap: (() -> Void)? = nil) {
        self.product = product
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeProductCardViewModel(product: product))
        self.onFavoriteTap = onFavoriteTap
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Image Section (fills top of card)
            ZStack(alignment: .topLeading) {
                imageView
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipped()

                // Fav icon overlay on image — prominent style
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                        favBounce = true
                    }
                    onFavoriteTap?() ?? viewModel.toggleFavorite(for: product)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        favBounce = false
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(viewModel.isFavorite ? .white : .gray.opacity(0.7))
                        .frame(width: 34, height: 34)
                        .background(
                            Circle()
                                .fill(viewModel.isFavorite
                                      ? Color.red
                                      : Color.white.opacity(0.92))
                                .shadow(
                                    color: viewModel.isFavorite
                                        ? Color.red.opacity(0.4)
                                        : Color.black.opacity(0.08),
                                    radius: viewModel.isFavorite ? 8 : 4,
                                    x: 0,
                                    y: 2
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    viewModel.isFavorite
                                        ? Color.red.opacity(0.3)
                                        : Color.gray.opacity(0.2),
                                    lineWidth: 1.5
                                )
                        )
                        .scaleEffect(favBounce ? 1.3 : 1.0)
                        .rotationEffect(.degrees(favBounce ? -12 : 0))
                }
                .buttonStyle(.plain)
                .padding(8)
                .animation(.spring(response: 0.35, dampingFraction: 0.5), value: viewModel.isFavorite)
            }

            // MARK: - Info Section
            VStack(alignment: .leading, spacing: 6) {

                Text(product.title)
                    .font(.system(size: 13, weight: .bold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Price row + color circles
                HStack(spacing: 6) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 5) {
                            Text("$\(product.price, specifier: "%.2f")")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blue)

                            if let compareAtPrice = product.compareAtPrice {
                                Text("$\(compareAtPrice, specifier: "%.2f")")
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .strikethrough()
                            }
                        }

                        if let discount = product.discountPercentage {
                            Text("\(discount)% OFF")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.red)
                        }
                    }

                    Spacer()

                    if !product.colors.isEmpty {
                        ProductColorsView(colorNames: product.colors)
                    }
                }

                AddToCartCounter(
                    quantity: viewModel.cartQuantity,
                    isOutOfStock: viewModel.isOutOfStock,
                    onAdd: { viewModel.addToCart() },
                    onIncrement: { viewModel.incrementQuantity() },
                    onDecrement: { viewModel.decrementQuantity() }
                )
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, 10)
        }
        .onAppear {
            print("Title: \(product.title)")
            print("Image URL: \(product.imageURL)")

            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.75)
                .delay(Double.random(in: 0...0.15))
            ) {
                appeared = true
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(0.04),
            radius: 6,
            x: 0,
            y: 3
        )
        .shadow(
            color: Color.orange.opacity(0.12),
            radius: 16,
            x: 0,
            y: 6
        )
        // Appear animation: fade + slide up
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 18)
        // Press interaction
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }

    @ViewBuilder
    private var imageView: some View {
        if let url = URL(string: product.imageURL), !product.imageURL.isEmpty {
            CachedProductImage(url: url)
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "photo")
            .font(.system(size: 28))
            .foregroundColor(.gray.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray6))
    }
}
