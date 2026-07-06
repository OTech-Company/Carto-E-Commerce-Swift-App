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

    init(product: Product, onFavoriteTap: (() -> Void)? = nil) {
        self.product = product
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makeProductCardViewModel(product: product))
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

            AddToCartCounter(
                quantity: viewModel.cartQuantity,
                isOutOfStock: viewModel.isOutOfStock,
                onAdd: { viewModel.addToCart() },
                onIncrement: { viewModel.incrementQuantity() },
                onDecrement: { viewModel.decrementQuantity() }
            )
        }
        .onAppear {
            print("Title: \(product.title)")
            print("Image URL: \(product.imageURL)")
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
    }
}
