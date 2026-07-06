//
//  AddressQueries.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation

enum StorefrontAddressQueries {

    static let createAddress = """
        mutation CustomerAddressCreate($customerAccessToken: String!, $address: MailingAddressInput!) {
          customerAddressCreate(customerAccessToken: $customerAccessToken, address: $address) {
            customerAddress {
              id
              address1
              address2
              city
              province
              country
              zip
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """

    static let updateAddress = """
        mutation CustomerAddressUpdate($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) {
          customerAddressUpdate(customerAccessToken: $customerAccessToken, id: $id, address: $address) {
            customerAddress {
              id
              address1
              address2
              city
              province
              country
              zip
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """

    static let deleteAddress = """
        mutation CustomerAddressDelete($customerAccessToken: String!, $id: ID!) {
          customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
            deletedCustomerAddressId
            customerUserErrors {
              field
              message
            }
          }
        }
        """

    static let setDefaultAddress = """
        mutation CustomerDefaultAddressUpdate($customerAccessToken: String!, $addressId: ID!) {
          customerDefaultAddressUpdate(customerAccessToken: $customerAccessToken, addressId: $addressId) {
            customer {
              id
              defaultAddress {
                id
                address1
                address2
                city
                province
                country
                zip
              }
            }
            customerUserErrors {
              field
              message
            }
          }
        }
        """
}
