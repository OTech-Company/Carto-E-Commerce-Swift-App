//
//  ProductDTO+Mapper.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//

extension ProductDTO {
    func toDomain() -> ProductInfo {
        ProductInfo(
            id: id ?? 0,
            title: title ?? "",
            price: Double(variants?.first?.price ?? "0") ?? 0,
            compareAtPrice: variants?.first?.compareAtPrice.flatMap { Double($0) },
            description: (bodyHtml ?? "").strippingHTMLTags(),
            imageURL: images?.first?.src ?? "",
            sizes: options?
                .first(where: { $0.name.lowercased() == "size" })?
                .values ?? [],
            colors: options?
                .first(where: { $0.name.lowercased() == "color" })?
                .values ?? []
        )
    }
}
