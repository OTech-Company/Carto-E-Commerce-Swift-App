//
//  BrandRemoteDataSource.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

protocol BrandRemoteDataSourceProtocol {
    func fetchBrands() async throws -> BrandResponseDTO
}

class BrandRemoteDataSource: BrandRemoteDataSourceProtocol {
    func fetchBrands() async throws -> BrandResponseDTO {
        do {
            let response: BrandResponseDTO = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .brands
            )

            print("Fetched brands count:", response.smartCollections.count)
            return response
        } catch {
            print("REST error:", error)
            throw error
        }
    }
}
