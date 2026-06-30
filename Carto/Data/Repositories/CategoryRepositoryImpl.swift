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
           
            struct CategoriesResponse: Decodable {
                let custom_collections: [CategoryDTO]?
            }
            
            let response: CategoriesResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .categories
            )
            
            let dtos = response.custom_collections ?? []
            let domainCategories = dtos.map { Category(from: $0) }
            
            print("=================")
            print(dtos)

            print("=================")
            print(domainCategories)
            return domainCategories
        } catch let decodingError as DecodingError {
            print("❌ JSON Decoding failed explicitly: \(decodingError)")
            throw decodingError
        } catch {
            print("❌ REST parsing/network error:", error)
            throw error
        }
    }
}
