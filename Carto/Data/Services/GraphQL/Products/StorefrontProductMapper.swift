//
//  StorefrontProductMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

extension StorefrontProduct {
    func toDomain() -> STProduct {
        STProduct(
            id: id,
            title: title,
            description: description,
            vendor: vendor,
            productType: productType,
            handle: handle,
            tags: tags,
            variants: variants.nodes.map { $0.toDomain() },
            images: images.nodes.map { $0.toDomain() },
            options: options?.map { $0.toDomain() } ?? []
        )
    }
}

extension StorefrontProductVariant {
    func toDomain() -> STVariant {
        STVariant(
            id: id,
            merchandiseId: id,
            title: title,
            price: price.amount,
            compareAtPrice: compareAtPrice?.amount,
            sku: sku,
            availableForSale: availableForSale,
            currencyCode: price.currencyCode
        )
    }
}

extension StorefrontImage {
    func toDomain() -> STImage {
        STImage(
            id: id,
            url: url,
            altText: altText
        )
    }
}

extension StorefrontOption {
    func toDomain() -> STOption {
        STOption(
            id: id,
            name: name,
            values: values
        )
    }
}
