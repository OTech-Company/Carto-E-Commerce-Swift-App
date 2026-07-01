//
//  BrandRemoteDataSource.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

protocol BrandRemoteDataSourceProtocol {
    func fetchBrands() async throws -> [BrandDTO]
}

class BrandRemoteDataSource: BrandRemoteDataSourceProtocol {
    func fetchBrands() async throws -> [BrandDTO] {
        do {
            struct AdminBrandsResponse: Decodable {
                let brands: [BrandDTO]?
            }

            let response: AdminBrandsResponse = try await ShopifyAPIClient.shared.requestREST(
                    endpoint: .brands,
                )

            print("Fetched brands:", response.brands?.count ?? 0)
            return response.brands ?? []
        } catch {
            print("REST error:", error.localizedDescription)
            throw error
        }
    }
}
