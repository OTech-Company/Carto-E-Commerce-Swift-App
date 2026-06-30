//
//  CategoryRepoProtocol.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation

protocol CategoryRepositoryProtocol {
    func fetchCategories() async throws -> [Category]
}
