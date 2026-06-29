//
//  ProductDTO+Mapper.swift
//  Carto
//
//  Created by Manona on 28/06/2026.
//


extension ProductDTO {

    func toDomain() -> ProductInfo {
        ProductInfo(
            id: id,
            title: title,
            price: Double(variants?.first?.price ?? "0") ?? 0,
            discount: "",
            imageURL: images?.first?.src ?? "",
            sizes: options?.first(where: { $0.name.lowercased() == "size" })?.values ?? [],
            colors: options?.first(where: { $0.name.lowercased() == "color" })?.values ?? []
        )
    }
}
