//
//  ProductDTO+Mapper.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//
import Foundation

extension ProductDTO {
    func toDomain() -> Product {
        Product(
            id: id ?? 0,
            title: title ?? "",
            description: (bodyHtml ?? "").strippingHTMLTags(),
            vendor: vendor ?? "",
            productType: productType ?? "",
            handle: handle ?? "",
            status: status ?? "",
            tags: (tags ?? "")
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty },
            variants: variants?.map {
                ProductVariant(
                    id: $0.id ?? 0,
                    productId: $0.productId ?? 0,
                    title: $0.title ?? "",
                    price: $0.price ?? "0",
                    sku: $0.sku ?? "",
                    compareAtPrice: $0.compareAtPrice,
                    inventoryQuantity: $0.inventoryQuantity ?? 0,
                    option1: $0.option1,
                    option2: $0.option2,
                    option3: $0.option3,
                    adminGraphqlApiId: $0.adminGraphqlApiId
                )
            } ?? [],
            images: images?.map {
                ProductImage(
                    id: $0.id ?? 0,
                    productId: $0.productId ?? 0,
                    alt: $0.alt ?? "",
                    src: $0.src ?? ""
                )
            } ?? [],
            options: options?.map {
                ProductOption(
                    id: $0.id ?? 0,
                    productId: $0.productId ?? 0,
                    name: $0.name ?? "",
                    values: $0.values ?? []
                )
            } ?? []
        )
    }
}

extension Product {
    init(from dto: ProductDTO) {
        self.id = dto.id ?? 0
        self.title = dto.title ?? "Untitled Product"
        self.description = dto.bodyHtml ?? ""
        self.vendor = dto.vendor ?? ""
        self.productType = dto.productType ?? ""
        self.handle = dto.handle ?? ""
        self.status = dto.status ?? ""
        self.tags = (dto.tags ?? "")
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        self.variants =
            dto.variants?.map {
                ProductVariant(
                    id: $0.id,
                    productId: $0.productId,
                    title: $0.title,
                    price: $0.price ?? "0",
                    sku: $0.sku ?? "",
                    compareAtPrice: $0.compareAtPrice,
                    inventoryQuantity: $0.inventoryQuantity ?? 0,
                    option1: $0.option1,
                    option2: $0.option2,
                    option3: $0.option3,
                    adminGraphqlApiId: $0.adminGraphqlApiId
                )
            } ?? []

        self.images =
            dto.images?.map {
                ProductImage(
                    id: $0.id,
                    productId: $0.productId,
                    alt: $0.alt ?? "",
                    src: $0.src ?? ""
                )
            } ?? []

        self.options =
            dto.options?.map {
                ProductOption(
                    id: $0.id,
                    productId: $0.productId,
                    name: $0.name,
                    values: $0.values ?? []
                )
            } ?? []
    }
}

extension ProductVariant {
    init(from dto: ProductVariantDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.title = dto.title
        self.price = dto.price ?? "0.00"
        self.sku = dto.sku ?? ""
        self.compareAtPrice = dto.compareAtPrice
        self.inventoryQuantity = dto.inventoryQuantity ?? 0
        self.option1 = dto.option1
        self.option2 = dto.option2
        self.option3 = dto.option3
        self.adminGraphqlApiId = dto.adminGraphqlApiId
    }
}

extension ProductImage {
    init(from dto: ProductImageDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.alt = dto.alt ?? ""
        self.src = dto.src ?? ""
    }
}

extension ProductOption {
    init(from dto: ProductOptionDTO) {
        self.id = dto.id
        self.productId = dto.productId
        self.name = dto.name
        self.values = dto.values ?? []
    }
}
