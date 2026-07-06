//
//  CartGraphQLRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

protocol CartRemoteDataSource {
    func fetchCart(id: String) async throws -> CartModel?
    func createCart(lines: [StorefrontCartLineInput]) async throws -> CartModel
    func addLines(cartId: String, lines: [StorefrontCartLineInput]) async throws -> CartModel
    func updateLines(cartId: String, lines: [StorefrontCartLineUpdateInput]) async throws -> CartModel
    func removeLines(cartId: String, lineIds: [String]) async throws -> CartModel
    func updateDiscountCodes(cartId: String, discountCodes: [String]) async throws -> CartModel
}

final class CartGraphQLRemoteDataSource: CartRemoteDataSource {

    private let client: GraphQLClient

    init(client: GraphQLClient = GraphQLStorefrontClient.shared) {
        self.client = client
    }

    func fetchCart(id: String) async throws -> CartModel? {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.fetchCart,
            variables: StorefrontFetchCartVariables(id: id),
            operationName: "FetchCart"
        )
        let response: StorefrontFetchCartResponse = try await client.request(request)
        return response.cart?.toDomain()
    }

    func createCart(lines: [StorefrontCartLineInput]) async throws -> CartModel {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.createCart,
            variables: StorefrontCreateCartVariables(input: StorefrontCartInput(lines: lines)),
            operationName: "CreateCart"
        )
        let response: StorefrontCartCreateResponse = try await client.request(request)
        return try response.cartCreate.toDomain()
    }

    func addLines(cartId: String, lines: [StorefrontCartLineInput]) async throws -> CartModel {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.addToCart,
            variables: StorefrontAddToCartVariables(cartId: cartId, lines: lines),
            operationName: "AddToCart"
        )
        let response: StorefrontCartLinesAddResponse = try await client.request(request)
        return try response.cartLinesAdd.toDomain()
    }

    func updateLines(cartId: String, lines: [StorefrontCartLineUpdateInput]) async throws -> CartModel {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.updateCartLines,
            variables: StorefrontUpdateCartLinesVariables(cartId: cartId, lines: lines),
            operationName: "UpdateCartLines"
        )
        let response: StorefrontCartLinesUpdateResponse = try await client.request(request)
        return try response.cartLinesUpdate.toDomain()
    }

    func removeLines(cartId: String, lineIds: [String]) async throws -> CartModel {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.removeCartLines,
            variables: StorefrontRemoveCartLinesVariables(cartId: cartId, lineIds: lineIds),
            operationName: "RemoveCartLines"
        )
        let response: StorefrontCartLinesRemoveResponse = try await client.request(request)
        return try response.cartLinesRemove.toDomain()
    }
    
    func updateDiscountCodes(cartId: String, discountCodes: [String]) async throws -> CartModel {
        let request = GraphQLRequest(
            query: StorefrontCartQueries.updateDiscountCodes,
            variables: StorefrontUpdateDiscountCodesVariables(cartId: cartId, discountCodes: discountCodes),
            operationName: "UpdateDiscountCodes"
        )
        let response: StorefrontCartDiscountCodesUpdateResponse = try await client.request(request)
        return try response.cartDiscountCodesUpdate.toDomain()
    }
}
