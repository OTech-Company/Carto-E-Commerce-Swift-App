//
//  Payment.swift
//  Carto
//
//  Created by Mohamed Ayman on 06/07/2026.
//
 
import Foundation

// MARK: - Admin Customer Update DTOs

struct AdminCustomerUpdateVariables: Encodable {
    let input: AdminCustomerUpdateInput
}

struct AdminCustomerUpdateInput: Encodable {
    let id: String
    let password: String
}

struct AdminCustomerUpdateResponse: Decodable {
    let customerUpdate: AdminCustomerUpdatePayload
}

struct AdminCustomerUpdatePayload: Decodable {
    let customer: AdminCustomerUpdateResult?
    let userErrors: [AdminCustomerUserError]
}

struct AdminCustomerUpdateResult: Decodable {
    let id: String
}

struct AdminCustomerUserError: Decodable {
    let field: [String]?
    let message: String
}

// MARK: - Admin Customer Update Mutation

enum AdminCustomerMutations {

    static let customerUpdate = """
        mutation CustomerUpdate($input: CustomerInput!) {
          customerUpdate(input: $input) {
            customer {
              id
            }
            userErrors {
              field
              message
            }
          }
        }
        """
}
