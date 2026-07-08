//
//  CartQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

private let merchandiseFragment = """
                      ... on ProductVariant {
                        id
                        title
                        image {
                          url
                        }
                        price {
                          amount
                          currencyCode
                        }
                        product {
                          id
                          title
                          handle
                        }
                      }
"""

private let cartBodyFragment = """
              id
              checkoutUrl
              totalQuantity
              lines(first: 50) {
                edges {
                  node {
                    id
                    quantity
                    merchandise {
\(merchandiseFragment)
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
              discountCodes {
                code
                applicable
              }
              cost {
                subtotalAmount {
                  amount
                  currencyCode
                }
                totalAmount {
                  amount
                  currencyCode
                }
                totalTaxAmount {
                  amount
                  currencyCode
                }
              }
"""

enum StorefrontCartQueries {

    static let fetchCart = """
        query FetchCart($id: ID!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cart(id: $id) {
        \(cartBodyFragment)
          }
        }
        """

    static let createCart = """
        mutation CreateCart($input: CartInput, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cartCreate(input: $input) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """

    static let addToCart = """
        mutation AddToCart($cartId: ID!, $lines: [CartLineInput!]!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cartLinesAdd(cartId: $cartId, lines: $lines) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """

    static let updateCartLines = """
        mutation UpdateCartLines($cartId: ID!, $lines: [CartLineUpdateInput!]!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cartLinesUpdate(cartId: $cartId, lines: $lines) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """

    static let removeCartLines = """
        mutation RemoveCartLines($cartId: ID!, $lineIds: [ID!]!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """

    static let updateDiscountCodes = """
        mutation UpdateDiscountCodes($cartId: ID!, $discountCodes: [String!]!, $country: CountryCode, $language: LanguageCode) @inContext(country: $country, language: $language) {
          cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """

    static let updateBuyerIdentity = """
        mutation UpdateCartBuyerIdentity($cartId: ID!, $buyerIdentity: CartBuyerIdentityInput!) {
          cartBuyerIdentityUpdate(cartId: $cartId, buyerIdentity: $buyerIdentity) {
            cart {
        \(cartBodyFragment)
            }
            userErrors {
              field
              message
            }
          }
        }
        """
}
