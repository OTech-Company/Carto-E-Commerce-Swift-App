//
//  CategoryRepositoryImpl.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//
import Foundation

final class CategoryRepository: CategoryRepositoryProtocol {
    
    func fetchCategories() async throws -> [Category] {
        do {
            // 1. Define the wrapper using CAMEL CASE to perfectly match `.convertFromSnakeCase`
            struct CategoriesResponse: Decodable {
                let customCollections: [CategoryDTO]?
            }
            
            // 2. Call the client
            let response: CategoriesResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .categories
            )
            
            // 3. Extract using camelCase
            let dtos = response.customCollections ?? []
            
            print("=================")
            print("Successfully Decoded DTOs Count: \(dtos.count)")
            print("=================")
            
            // Map directly to domain models
            return dtos.map { Category(from: $0) }
            
        } catch {
            print("❌ Repository Error:", error)
            throw error
        }
    }
}
