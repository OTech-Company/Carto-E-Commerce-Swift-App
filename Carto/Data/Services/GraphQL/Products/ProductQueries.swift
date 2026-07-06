//
//  ProductQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontProductQueries {

    static let fetchProducts = """
        query FetchProducts($first: Int!, $after: String) {
          products(first: $first, after: $after) {
            edges {
              node {
                id
                title
                handle
                description
                vendor
                productType
                tags
                images(first: 10) {
                  edges {
                    node {
                      id
                      url
                      altText
                    }
                  }
                  pageInfo {
                    hasNextPage
                    hasPreviousPage
                    startCursor
                    endCursor
                  }
                }
                variants(first: 10) {
                  edges {
                    node {
                      id
                      title
                      sku
                      availableForSale
                      price {
                        amount
                        currencyCode
                      }
                      compareAtPrice {
                        amount
                        currencyCode
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
                options(first: 10) {
                  id
                  name
                  values
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
        """

    static let fetchProductByHandle = """
        query FetchProductByHandle($handle: String!) {
          productByHandle(handle: $handle) {
            id
            title
            handle
            description
            vendor
            productType
            tags
            images(first: 20) {
              edges {
                node {
                  id
                  url
                  altText
                }
              }
              pageInfo {
                hasNextPage
                hasPreviousPage
                startCursor
                endCursor
              }
            }
            variants(first: 20) {
              edges {
                node {
                  id
                  title
                  sku
                  availableForSale
                  price {
                    amount
                    currencyCode
                  }
                  compareAtPrice {
                    amount
                    currencyCode
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
            options(first: 10) {
              id
              name
              values
            }
          }
        }
        """

    static let searchProducts = """
        query SearchProducts($query: String!, $first: Int!) {
          products(query: $query, first: $first) {
            edges {
              node {
                id
                title
                handle
                description
                vendor
                productType
                tags
                images(first: 5) {
                  edges {
                    node {
                      id
                      url
                      altText
                    }
                  }
                  pageInfo {
                    hasNextPage
                    hasPreviousPage
                    startCursor
                    endCursor
                  }
                }
                variants(first: 5) {
                  edges {
                    node {
                      id
                      title
                      sku
                      availableForSale
                      price {
                        amount
                        currencyCode
                      }
                      compareAtPrice {
                        amount
                        currencyCode
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
                options(first: 5) {
                  id
                  name
                  values
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
        """
}
