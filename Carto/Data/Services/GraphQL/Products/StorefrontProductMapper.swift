//
//  StorefrontProductMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

private func extractNumericId(from gid: String) -> Int {
    let components = gid.split(separator: "/")
    guard let last = components.last, let id = Int(last) else { return 0 }
    return id
}

extension StorefrontProduct {
    func toDomain() -> Product {
        let productId = extractNumericId(from: id)
        return Product(
            id: productId,
            title: title,
            description: description ?? "",
            vendor: vendor ?? "",
            productType: productType ?? "",
            handle: handle,
            status: status ?? "",
            tags: tags,
            variants: variants.nodes.map { $0.toDomain(productId: productId) },
            images: images.nodes.map { $0.toDomain(productId: productId) },
            options: options?.map { opt in
                let optionId = opt.id.flatMap { extractNumericId(from: $0) } ?? 0
                return ProductOption(id: optionId, productId: productId, name: opt.name, values: opt.values)
            } ?? []
        )
    }
}

extension StorefrontProductVariant {
    func toDomain(productId: Int) -> ProductVariant {
        let variantId = extractNumericId(from: id)
        return ProductVariant(
            id: variantId,
            productId: productId,
            title: title,
            price: price.amount,
            sku: sku ?? "",
            compareAtPrice: compareAtPrice?.amount,
            inventoryQuantity: 0
        )
    }
}

extension StorefrontImage {
    func toDomain(productId: Int) -> ProductImage {
        let imageId = id.flatMap { extractNumericId(from: $0) } ?? 0
        return ProductImage(id: imageId, productId: productId, alt: altText ?? "", src: url)
    }
}
