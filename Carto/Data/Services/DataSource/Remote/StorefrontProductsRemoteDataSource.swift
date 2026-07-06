//
//  StorefrontProductsRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

protocol StorefrontProductsRemoteDataSourceProtocol {
    func fetchProducts(first: Int, after: String?) async throws -> StorefrontPage<STProduct>
    func fetchProduct(handle: String) async throws -> STProduct?
    func searchProducts(query: String, first: Int) async throws -> StorefrontPage<STProduct>
}

final class StorefrontProductsRemoteDataSource: StorefrontProductsRemoteDataSourceProtocol {

    private let client: GraphQLClient

    init(client: GraphQLClient = GraphQLStorefrontClient.shared) {
        self.client = client
    }

    func fetchProducts(first: Int, after: String? = nil) async throws -> StorefrontPage<STProduct> {
        let request = GraphQLRequest(query: StorefrontProductQueries.fetchProducts,
                                     variables: StorefrontProductsVariables(first: first, after: after),
                                     operationName: "FetchProducts")
        let response: StorefrontProductsResponse = try await client.request(request)
        return response.products.toStorefrontPage { $0.toDomain() }
    }

    func fetchProduct(handle: String) async throws -> STProduct? {
        let request = GraphQLRequest(query: StorefrontProductQueries.fetchProductByHandle,
                                     variables: StorefrontProductByHandleVariables(handle: handle),
                                     operationName: "FetchProductByHandle")
        let response: StorefrontProductResponse = try await client.request(request)
        return response.productByHandle?.toDomain()
    }

    func searchProducts(query: String, first: Int) async throws -> StorefrontPage<STProduct> {
        let request = GraphQLRequest(query: StorefrontProductQueries.searchProducts,
                                     variables: StorefrontSearchProductsVariables(query: query, first: first),
                                     operationName: "SearchProducts")
        let response: StorefrontProductsResponse = try await client.request(request)
        return response.products.toStorefrontPage { $0.toDomain() }
    }
}
