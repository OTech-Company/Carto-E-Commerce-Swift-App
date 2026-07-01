//
//  BrandDTO.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Foundation

struct BrandResponseDTO: Decodable {
    let smartCollections: [BrandDTO]
}

struct BrandDTO: Decodable {
    let id: Int
    let handle: String
    let title: String
    let updatedAt: String
    let publishedAt: String
    let sortOrder: String
    let image: BrandImageDTO?
}

struct BrandImageDTO: Decodable {
    let createdAt: String
    let alt: String?
    let width: Int
    let height: Int
    let src: String
}

extension BrandResponseDTO {
    func toDomainModel() -> [BrandEntity] {
        smartCollections.map { $0.toDomainModel() }
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
