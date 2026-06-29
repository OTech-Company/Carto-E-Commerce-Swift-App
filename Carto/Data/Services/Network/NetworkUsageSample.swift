import Foundation

/// Small examples showing how to use the network layer for REST and GraphQL.
enum NetworkUsageSample {

    // MARK: - REST sample
    static func fetchProducts() async {
        do {
            let products: ShopifyResponse<[ProductDTO]> = try await ShopifyAPIClient.shared.requestREST(
                endpoint: .products,
                queryParams: [
                    "limit": "50",
                    "fields": "id,title,handle,vendor,product_type,status,variants,images,tags,created_at,updated_at"
                ]
            )

            print("Fetched products:", products.data?.count ?? 0)
        } catch {
            print("REST error:", error.localizedDescription)
        }
    }

    // MARK: - GraphQL sample
    struct ProductQueryVariables: Encodable {
        let id: String
    }

    struct ProductQueryResponse: Decodable {
        let product: ProductDTO?
    }

    static func fetchProductWithGraphQL(id: String) async {
        let query = """
        query GetProduct($id: ID!) {
          product(id: $id) {
            id
            title
            descriptionHtml
            vendor
            productType
          }
        }
        """

        do {
            let response: ProductQueryResponse = try await ShopifyAPIClient.shared.requestGraphQL(
                query: query,
                variables: ProductQueryVariables(id: id),
                operationName: "GetProduct",
                useStorefrontToken: true
            )

            print("Fetched product:", response.product?.title ?? "nil")
        } catch {
            print("GraphQL error:", error.localizedDescription)
        }
    }

    static func searchProductsWithGraphQL(queryText: String) async {
        let query = """
        query SearchProducts($query: String!, $first: Int!, $after: String) {
          search(query: $query, first: $first, after: $after, types: [PRODUCT]) {
            totalCount
            edges {
              cursor
              node {
                ... on Product {
                  id
                  title
                  vendor
                  availableForSale
                }
              }
            }
            pageInfo { hasNextPage endCursor }
          }
        }
        """

        struct Variables: Encodable {
            let query: String
            let first: Int
            let after: String?
        }

        struct SearchResponse: Decodable {
            struct SearchPayload: Decodable {
                struct Edge: Decodable {
                    struct Node: Decodable {
                        let id: String
                        let title: String
                        let vendor: String?
                        let availableForSale: Bool?
                    }

                    let cursor: String
                    let node: Node?
                }

                struct PageInfo: Decodable {
                    let hasNextPage: Bool
                    let endCursor: String?
                }

                let totalCount: Int?
                let edges: [Edge]
                let pageInfo: PageInfo?
            }

            let search: SearchPayload?
        }

        do {
            let response: SearchResponse = try await ShopifyAPIClient.shared.requestGraphQL(
                query: query,
                variables: Variables(query: queryText, first: 20, after: nil),
                operationName: "SearchProducts",
                useStorefrontToken: true
            )

            print("Search result count:", response.search?.totalCount ?? 0)
        } catch {
            print("GraphQL search error:", error.localizedDescription)
        }
    }
}
