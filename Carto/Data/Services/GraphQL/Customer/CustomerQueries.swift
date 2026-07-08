//
//  CustomerQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontCustomerQueries {

    static let fetchCustomer = """
        query FetchCustomer($customerAccessToken: String!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          customer(customerAccessToken: $customerAccessToken) {
            id
            firstName
            lastName
            email
            phone
            defaultAddress {
              id
              address1
              address2
              city
              province
              country
              zip
              phone
              firstName
              lastName
              company
            }
            addresses(first: 10) {
              edges {
                node {
                  id
                  address1
                  address2
                  city
                  province
                  country
                  zip
                  phone
                  firstName
                  lastName
                  company
                }
              }
              pageInfo {
                hasNextPage
                hasPreviousPage
                startCursor
                endCursor
              }
            }
            orders(first: 20) {
              edges {
                node {
                  id
                  orderNumber
                  processedAt
                  financialStatus
                  fulfillmentStatus
                  totalPrice {
                    amount
                    currencyCode
                  }
                  lineItems(first: 10) {
                    edges {
                      node {
                        title
                        quantity
                      }
                    }
                    pageInfo {
                      hasNextPage
                      hasPreviousPage
                      startCursor
                      endCursor
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                hasPreviousPage
                startCursor
                endCursor
              }
            }
          }
        }
        """

    static let customerAccessTokenCreate = """
        mutation CustomerAccessTokenCreate($input: CustomerAccessTokenCreateInput!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          customerAccessTokenCreate(input: $input) {
            customerAccessToken {
              accessToken
              expiresAt
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """

    static let customerAccessTokenDelete = """
        mutation CustomerAccessTokenDelete($customerAccessToken: String!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          customerAccessTokenDelete(customerAccessToken: $customerAccessToken) {
            deletedAccessToken
            userErrors {
              field
              message
            }
          }
        }
        """

    static let customerCreate = """
        mutation CustomerCreate($input: CustomerCreateInput!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          customerCreate(input: $input) {
            customer {
              id
              firstName
              lastName
              email
              phone
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """
}
