//
//  OrderRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

protocol OrderRemoteDataSource {
    func fetchOrders(accessToken: String, first: Int, after: String?) async throws -> StorefrontPage<CustomerOrder>
    func fetchOrderDetail(id: String) async throws -> CustomerOrderDetail?
}

final class OrderGraphQLRemoteDataSource: OrderRemoteDataSource {

    private let client: GraphQLClient

    init(client: GraphQLClient = GraphQLStorefrontClient.shared) {
        self.client = client
    }

    func fetchOrders(accessToken: String, first: Int, after: String? = nil) async throws -> StorefrontPage<CustomerOrder> {
        let request = GraphQLRequest(
            query: StorefrontOrderQueries.fetchOrders,
            variables: StorefrontOrdersVariables(customerAccessToken: accessToken, first: first, after: after),
            operationName: "FetchOrders"
        )
        let response: StorefrontOrdersResponse = try await client.request(request)

        guard let connection = response.customer?.orders else {
            return StorefrontPage(items: [], hasNextPage: false, endCursor: nil)
        }
        return connection.toStorefrontPage{ $0.toDomain() }
    }

    func fetchOrderDetail(id: String) async throws -> CustomerOrderDetail? {
        let request = GraphQLRequest(
            query: StorefrontOrderQueries.fetchOrderDetail,
            variables: StorefrontOrderDetailVariables(id: id),
            operationName: "FetchOrderDetail"
        )
        let response: StorefrontOrderDetailResponse = try await client.request(request)
        return response.node?.toDomain()
    }
}
