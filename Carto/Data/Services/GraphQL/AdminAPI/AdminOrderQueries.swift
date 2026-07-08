//
//  AdminOrderQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import Foundation

enum AdminOrderQueries {

    static let orderCreate = """
        mutation OrderCreate($order: OrderCreateOrderInput!, $options: OrderCreateOptionsInput) {
          orderCreate(order: $order, options: $options) {
            order {
              id
              name
              createdAt
              displayFinancialStatus
              totalPriceSet {
                shopMoney {
                  amount
                  currencyCode
                }
              }
            }
            userErrors {
              field
              message
            }
          }
        }
        """
}
