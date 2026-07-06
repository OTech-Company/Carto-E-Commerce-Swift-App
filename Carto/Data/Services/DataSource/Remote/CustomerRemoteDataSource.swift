//
//  CustomerGraphQLRemoteDataSource.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

protocol CustomerRemoteDataSource {
    func fetchCustomer(accessToken: String) async throws -> Customer?
    func login(email: String, password: String) async throws -> CustomerAuthToken
    func logout(accessToken: String) async throws -> Bool
    func register(email: String, password: String, firstName: String?, lastName: String?) async throws -> Customer
}

final class CustomerGraphQLRemoteDataSource: CustomerRemoteDataSource {

    private let client: GraphQLClient

    init(client: GraphQLClient = GraphQLStorefrontClient.shared) {
        self.client = client
    }

    func fetchCustomer(accessToken: String) async throws -> Customer? {
        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.fetchCustomer,
            variables: StorefrontCustomerVariables(customerAccessToken: accessToken),
            operationName: "FetchCustomer"
        )
        let response: StorefrontCustomerResponse = try await client.request(request)
        return response.customer?.toDomain()
    }

    func login(email: String, password: String) async throws -> CustomerAuthToken {
        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.customerAccessTokenCreate,
            variables: StorefrontCustomerAccessTokenCreateVariables(
                input: StorefrontCustomerAccessTokenCreateInput(email: email, password: password)
            ),
            operationName: "CustomerAccessTokenCreate"
        )
        let response: StorefrontCustomerAccessTokenCreateResponse = try await client.request(request)
        return try response.customerAccessTokenCreate.toDomain()
    }

    func logout(accessToken: String) async throws -> Bool {
        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.customerAccessTokenDelete,
            variables: StorefrontCustomerAccessTokenDeleteVariables(customerAccessToken: accessToken),
            operationName: "CustomerAccessTokenDelete"
        )
        let response: StorefrontCustomerAccessTokenDeleteResponse = try await client.request(request)

        guard let payload = response.customerAccessTokenDelete else {
            throw GraphQLStorefrontNetworkError.decodingFailed(
                DecodingError.valueNotFound(
                    StorefrontCustomerAccessTokenDeletePayload.self,
                    .init(codingPath: [], debugDescription: "customerAccessTokenDelete returned null — check server errors")
                )
            )
        }

        guard payload.userErrors.isEmpty else {
            throw StorefrontCustomerError.userErrors(payload.userErrors.map { $0.message })
        }
        return payload.deletedAccessToken != nil
    }

    func register(
        email: String,
        password: String,
        firstName: String?,
        lastName: String?
    ) async throws -> Customer {
        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.customerCreate,
            variables: StorefrontCustomerCreateVariables(
                input: StorefrontCustomerCreateInput(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName
                )
            ),
            operationName: "CustomerCreate"
        )
        let response: StorefrontCustomerCreateResponse = try await client.request(request)
        return try response.customerCreate.toDomain()
    }
}
