//
//  ProductsRemoteDataSource.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import Foundation

protocol ProductsRemoteDataSource {
    func getProductsByBrand(brandId: Int) async throws -> [ProductDTO]
    func getAllProducts() async throws -> [ProductDTO]
}

class ProductsRemoteDataSourceImpl: ProductsRemoteDataSource {
    
    func getAllProducts() async throws -> [ProductDTO] {
        do {
            let response: ProductListResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .products
            )

            let products = response.products ?? []
            print("Fetched products:", products.count)
            return products
        } catch {
            print("REST error:", error)
            throw error
        }            
    }

    func getProductsByBrand(brandId: Int) async throws -> [ProductDTO] {
        do {
            let response: CategoryProductsResponse = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .productsByBrand(id: String(brandId))
            )

            let products = response.products ?? []
            print("Fetched products by brands count:", products.count)
            return products
        } catch {
            print("REST error:", error)
            throw error
        }
    }
    
    
}
