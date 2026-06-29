//
//  ProductsInfoRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

class ProductsRemoteDataSource {

    func getProductInfo(productId: String) async throws -> ProductDTO {

        ProductDTO(
            id: productId,
            title: "Air Max 200 SE",
            descriptionHtml: "Nike Air Max",
            vendor: "Nike",
            productType: "Shoes",
            tags: [],
            images: [
                ImageDTO(
                    id: nil,
                    src: "shoes",
                    altText: nil
                )
            ],
            variants: [
                VariantDTO(
                    id: "1",
                    title: "Default",
                    price: "30.99",
                    compareAtPrice: "34.99",
                    availableForSale: true,
                    sku: nil,
                    selectedOptions: nil
                )
            ],
            options: [
                ProductOptionDTO(
                    name: "Size",
                    values: ["UK 6","UK 7","UK 8","UK 9"]
                ),
                ProductOptionDTO(
                    name: "Color",
                    values: ["Red","Blue"]
                )
            ]
        )
    }
}
