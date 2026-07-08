//
//  OrderQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontOrderQueries {

    static let fetchOrders = """
        query FetchOrders($customerAccessToken: String!, $first: Int!, $after: String, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          customer(customerAccessToken: $customerAccessToken) {
            orders(first: $first, after: $after, sortKey: PROCESSED_AT, reverse: true) {
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

    static let fetchOrderDetail = """
        query FetchOrderDetail($id: ID!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          node(id: $id) {
            ... on Order {
              id
              orderNumber
              processedAt
              financialStatus
              fulfillmentStatus
              email
              phone
              subtotalPrice {
                amount
                currencyCode
              }
              totalShippingPrice {
                amount
                currencyCode
              }
              totalTax {
                amount
                currencyCode
              }
              totalPrice {
                amount
                currencyCode
              }
              shippingAddress {
                name
                address1
                address2
                city
                province
                country
                zip
              }
              successfulFulfillments(first: 5) {
                trackingCompany
                trackingInfo(first: 5) {
                  number
                  url
                }
              }
              lineItems(first: 50) {
                edges {
                  node {
                    title
                    quantity
                    variant {
                      id
                      title
                      price {
                        amount
                        currencyCode
                      }
                      image {
                        url
                        altText
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
        }
        """
}
