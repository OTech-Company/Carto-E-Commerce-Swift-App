//
//  BrandsRepoProtocol.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import Foundation

protocol BrandsRepoProtocol {
    func fetchBrands() async throws -> [BrandEntity]
}
