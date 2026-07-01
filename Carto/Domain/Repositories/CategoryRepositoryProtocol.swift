//
//  CategoryRepoProtocol.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import Foundation

protocol CategoryRepositoryProtocol {
    func fetchCategories() async throws -> [Category]
    func fetchSubcategoriesWithImages(forCollectionId collectionId: String) async throws -> [Subcategory]
    func fetchAllAvailableSubcategories() async throws -> [String]
    func fetchCategoryProducts(categoryId: String) async throws -> [Product]
}
