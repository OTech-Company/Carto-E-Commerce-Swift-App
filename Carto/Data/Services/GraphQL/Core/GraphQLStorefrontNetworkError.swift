//
//  GraphQLStorefrontNetworkError.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum GraphQLStorefrontNetworkError: LocalizedError {
    case invalidURL
    case noInternet
    case timeout
    case unauthorized
    case notFound
    case serverError
    case requestFailed(Int)
    case decodingFailed(Error)
    case graphQLError([String])
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid GraphQL endpoint URL"
        case .noInternet:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .unauthorized:
            return "Unauthorized (401). Check storefront token validity."
        case .notFound:
            return "Endpoint not found (404)"
        case .serverError:
            return "Server error (5xx)"
        case .requestFailed(let code):
            return "Request failed with status \(code)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .graphQLError(let messages):
            return "GraphQL errors: \(messages.joined(separator: "; "))"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .invalidURL:
            return "Verify shop domain and API version are configured correctly"
        case .noInternet:
            return "Check your internet connection"
        case .timeout:
            return "The request took too long. Try again or increase timeout interval"
        case .unauthorized:
            return "Verify your Shopify Storefront access token is valid"
        case .notFound:
            return "Verify the endpoint path is correct"
        case .serverError:
            return "Shopify servers may be experiencing issues. Try again later"
        case .requestFailed:
            return "Check request parameters and try again"
        case .decodingFailed:
            return "Response format may have changed. Check API schema"
        case .graphQLError:
            return "Review the GraphQL query for errors"
        case .unknown:
            return "Try again or contact support"
        }
    }
}
