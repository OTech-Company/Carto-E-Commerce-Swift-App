//
//  ProductsInfoRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

class ProductsRemoteDataSourceImpl: ProductsRemoteDataSource {

    func getProductInfo(productId: Int) async throws -> ProductDTO {
        // Match the updated, flat, REST-compliant ProductDTO structure
        return ProductDTO(
            id: productId, // Expects Int to resolve type mismatches
            title: "Air Max 200 SE",
            bodyHtml: "<p>A comfortable pair of sneakers. Nike Air Max</p>", // Replaces descriptionHtml
            vendor: "Nike",
            productType: "Shoes",
            handle: "air-max-200-se",
            status: "active",
            tags: "running, sport", // Shopify REST exposes tags as a single comma-separated string
            variants: [
                ProductVariantDTO(
                    id: 1122334455,
                    productId: productId,
                    title: "Default",
                    price: "30.99", // Flat string price value matching REST pattern
                    sku: "AIR-MAX-200-SE",
                    position: 1,
                    inventoryPolicy: "deny",
                    compareAtPrice: "34.99",
                    fulfillmentService: "manual",
                    inventoryManagement: "shopify",
                    option1: "UK 6",
                    option2: "Red",
                    option3: nil,
                    taxable: true,
                    barcode: "190284729104",
                    grams: 400,
                    weight: 0.4,
                    weightUnit: "kg",
                    inventoryItemId: 99887766,
                    inventoryQuantity: 10,
                    oldInventoryQuantity: 10,
                    requiresShipping: true,
                    adminGraphqlApiId: "gid://shopify/ProductVariant/1122334455"
                )
            ],
            images: [
                ProductImageDTO(
                    id: 5544332211,
                    productId: productId,
                    position: 1,
                    createdAt: "2026-06-30T12:00:00-04:00",
                    updatedAt: "2026-06-30T12:05:00-04:00",
                    alt: "Air Max Side View",
                    width: 1000,
                    height: 1000,
                    src: "https://cdn.shopify.com/s/files/1/mock/shoes.png", // Correct mock asset URL path string
                    variantIds: [1122334455],
                    adminGraphqlApiId: "gid://shopify/ProductImage/5544332211"
                )
            ],
            options: [
                ProductOptionDTO(
                    id: 77665544,
                    productId: productId,
                    name: "Size",
                    position: 1,
                    values: ["UK 6", "UK 7", "UK 8", "UK 9"]
                ),
                ProductOptionDTO(
                    id: 77665545,
                    productId: productId,
                    name: "Color",
                    position: 2,
                    values: ["Red", "Blue"]
                )
            ]
        )
    }
}
