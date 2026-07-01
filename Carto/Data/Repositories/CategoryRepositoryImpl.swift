//
//  CategoryRepositoryImpl.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//
import Foundation

final class CategoryRepositoryImpl: CategoryRepositoryProtocol {
    
    func fetchCategories() async throws -> [Category] {
        do {

            let response: CategoriesResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .categories
            )
            
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
    
    
    func fetchSubcategoriesWithImages(forCollectionId collectionId: String) async throws -> [Subcategory] {
            do {
                // Include 'images' field inside your minimized payload request
                let queryParams = ["fields": "id,title,product_type,images"]
                
                let response: CategoryProductsResponse = try await ShopifyAPIClient.shared.requestREST(
                    endpoint: .productsByCategory(id: collectionId),
                    queryParams: queryParams
                )
                
                let products = response.products ?? []
                
                // Temporary dictionary to keep track of unique names and capture the first valid image
                var subcategoryMap: [String: String?] = [:]
                
                for product in products {
                    guard let typeName = product.productType,
                          !typeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                    
                    // If we haven't cataloged this subcategory yet, add it
                    if subcategoryMap[typeName] == nil {
                        let firstImageSrc = product.images?.first?.src
                        subcategoryMap[typeName] = firstImageSrc
                    }
                }
                
                // Map the unique collection into your Subcategory array sorted alphabetically
                let subcategories = subcategoryMap.map { (name, imageUrl) in
                    Subcategory(name: name, imageUrl: imageUrl)
                }.sorted { $0.name < $1.name }
                
                print("🚀 Extracted \(subcategories.count) subcategories with images successfully.")
                return subcategories
                
            } catch {
                print("❌ Repository Error while extracting subcategory visuals:", error)
                throw error
            }
        }
    
    func fetchAllAvailableSubcategories() async throws -> [String] {
        do {
            let queryParams = [
                "limit": "250",
                "fields": "product_type"
            ]
            
            let response: CategoryProductsResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .products,
                queryParams: queryParams
            )
            
            let products = response.products ?? []
            let uniqueTypes = Set(products.compactMap { $0.productType })
                .filter { !$0.isEmpty }
                
            return Array(uniqueTypes).sorted()
            
        } catch {
            print("❌ Error extracting master subcategories:", error)
            throw error
        }
    }
    
    func fetchCategoryProducts(categoryId: String) async throws -> [Product]{
        do {


            // Call the client
            let response: CategoryProductsResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .productsByCategory(id: categoryId)
            )
            
            let dtos = response.products ?? []
            
            print("=================")
            print("Successfully Decoded DTOs Count: \(dtos.count)")
            print("=================")
            
            for product in dtos {
                print("------------")
                print("Title:", product.title ?? "nil")
                print("Variants:", product.variants?.count ?? 0)
                print("Options:", product.options?.count ?? 0)
                print(product.options ?? [])
            }
            
            // Map directly to domain models
            return dtos.map { Product(from: $0) }
            
            
        } catch {
            print("❌ Repository Error:", error)
            throw error
        }
    }

}
