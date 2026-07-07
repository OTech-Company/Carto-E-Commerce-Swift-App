//
//  Payment.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//

import Foundation


final class ShopifyAuthenticationService: ShopifyAuthenticationServiceProtocol {

    private let storefrontClient: GraphQLClient
    private let restClient: ShopifyAPIClient

    init(
        storefrontClient: GraphQLClient = GraphQLStorefrontClient.shared,
        restClient: ShopifyAPIClient = ShopifyAPIClient.shared
    ) {
        self.storefrontClient = storefrontClient
        self.restClient = restClient
    }

    // MARK: - Create Customer (Storefront — Registration only)

    func createCustomer(
        email: String,
        password: String,
        firstName: String,
        lastName: String
    ) async throws -> String {

        let variables = StorefrontCustomerCreateVariables(
            input: StorefrontCustomerCreateInput(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName
            )
        )

        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.customerCreate,
            variables: variables,
            operationName: "CustomerCreate"
        )

        do {
            let response: StorefrontCustomerCreateResponse = try await storefrontClient.request(request)
            let customer = try mapCustomerCreatePayload(response.customerCreate)
            return customer.id
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.shopifyCustomerCreationFailed(error.localizedDescription)
        }
    }

    // MARK: - Create Access Token (Storefront)

    func createAccessToken(email: String, password: String) async throws -> String {

        let variables = StorefrontCustomerAccessTokenCreateVariables(
            input: StorefrontCustomerAccessTokenCreateInput(email: email, password: password)
        )

        let request = GraphQLRequest(
            query: StorefrontCustomerQueries.customerAccessTokenCreate,
            variables: variables,
            operationName: "CustomerAccessTokenCreate"
        )

        do {
            let response: StorefrontCustomerAccessTokenCreateResponse = try await storefrontClient.request(request)
            return try mapAccessTokenPayload(response.customerAccessTokenCreate)
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.shopifyTokenGenerationFailed(error.localizedDescription)
        }
    }

    // MARK: - Update Customer Password (Admin — Login only)

    func updateCustomerPassword(shopifyCustomerId: String, newPassword: String) async throws {

        let numericId = shopifyCustomerId.components(separatedBy: "/").last ?? shopifyCustomerId

        let body: [String: Any] = [
            "customer": [
                "id": Int(numericId) ?? 0,
                "password": newPassword,
                "password_confirmation": newPassword
            ]
        ]

        do {
            let _: RESTCustomerUpdateResponse = try await restClient.requestREST(
                endpoint: .updateCustomer(id: numericId),
                body: body
            )
        } catch {
            throw AuthError.shopifyAdminUpdateFailed(error.localizedDescription)
        }
    }

    // MARK: - Private Mappers

    private func mapCustomerCreatePayload(_ payload: StorefrontCustomerCreatePayload) throws -> StorefrontCustomerProfile {
        guard payload.customerUserErrors.isEmpty else {
            let messages = payload.customerUserErrors.map { $0.message }.joined(separator: "; ")
            throw AuthError.shopifyCustomerCreationFailed(messages)
        }
        guard let customer = payload.customer else {
            throw AuthError.shopifyCustomerCreationFailed("No customer returned from Storefront API.")
        }
        return customer
    }

    private func mapAccessTokenPayload(_ payload: StorefrontCustomerAccessTokenCreatePayload) throws -> String {
        guard payload.customerUserErrors.isEmpty else {
            let messages = payload.customerUserErrors.map { $0.message }.joined(separator: "; ")
            throw AuthError.shopifyTokenGenerationFailed(messages)
        }
        guard let token = payload.customerAccessToken?.accessToken else {
            throw AuthError.shopifyTokenGenerationFailed("No access token returned from Storefront API.")
        }
        return token
    }
}

struct RESTCustomerUpdateResponse: Decodable {
    let customer: RESTCustomerUpdateResult?
}

struct RESTCustomerUpdateResult: Decodable {
    let id: Int
}
