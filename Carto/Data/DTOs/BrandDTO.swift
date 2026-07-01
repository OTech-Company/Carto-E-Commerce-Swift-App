//
//  BrandDTO.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Foundation

struct BrandResponseDTO: Decodable {
    let smartCollections: [BrandDTO]

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

struct BrandDTO: Decodable {
    let id: Int
    let handle: String
    let title: String
    let updatedAt: String
    let publishedAt: String
    let sortOrder: String
    let image: BrandImageDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case handle
        case title
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case image
    }
}

struct BrandImageDTO: Decodable {
    let createdAt: String
    let alt: String?
    let width: Int
    let height: Int
    let src: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case alt
        case width
        case height
        case src
    }
}

extension BrandDTO {
    func toDomainModel() -> BrandEntity {
        return BrandEntity(
            id: id,
            handle: handle,
            title: title,
            updatedAt: updatedAt,
            publishedAt: publishedAt,
            sortOrder: sortOrder,
            image: image?.src
        )
    }
}
