//
//  ProductsInfoRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//
//
//  ProductsInfoRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

class ProductsRemoteDataSourceImpl: ProductsRemoteDataSource {

    func getProductInfo(productId: String) async throws -> ProductDTO {
        
        return ProductDTO(
            id: productId,
            title: "Air Max 200 SE",
            description: "A comfortable pair of sneakers.",
            descriptionHtml: "<p>Nike Air Max</p>",
            vendor: "Nike",
            productType: "Shoes",
            tags: ["running", "sport"],
            availableForSale: true,
            priceRange: PriceRangeDTO(
                minVariantPrice: MoneyDTO(amount: "30.99", currencyCode: "USD"),
                maxVariantPrice: MoneyDTO(amount: "34.99", currencyCode: "USD")
            ),
            compareAtPriceRange: nil,
            images: [
                ImageDTO(
                    id: "img1",
                    src: "shoes",
                    altText: "Air Max Side View"
                )
            ],
            variants: [
                VariantDTO(
                    id: "1",
                    title: "Default",
                    price: MoneyDTO(amount: "30.99", currencyCode: "USD"),
                    compareAtPrice: MoneyDTO(amount: "34.99", currencyCode: "USD"),
                    availableForSale: true,
                    quantityAvailable: 10,
                    sku: "AIR-MAX-200-SE",
                    selectedOptions: nil,
                    image: nil
                )
            ],
            options: [
                ProductOptionDTO(
                    name: "Size",
                    values: ["UK 6", "UK 7", "UK 8", "UK 9"]
                ),
                ProductOptionDTO(
                    name: "Color",
                    values: ["Red", "Blue"]
                )
            ]
        )
    }
}
