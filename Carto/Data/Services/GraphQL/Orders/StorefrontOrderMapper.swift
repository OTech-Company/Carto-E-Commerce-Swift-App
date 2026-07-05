//
//  StorefrontOrderMapper.swift
//  Carto
//
//  Created by Mohamed Ayman on 04/07/2026.
//

import Foundation


extension StorefrontOrderDetail {
    func toDomain() -> CustomerOrderDetail {
        CustomerOrderDetail(
            id: id,
            orderNumber: orderNumber,
            processedAt: processedAt,
            financialStatus: financialStatus ?? "",
            fulfillmentStatus: fulfillmentStatus ?? "",
            email: email,
            phone: phone,
            subtotal: subtotalPrice?.amount,
            shipping: totalShippingPrice?.amount,
            tax: totalTax?.amount,
            total: totalPrice.amount,
            currencyCode: totalPrice.currencyCode,
            shippingAddress: shippingAddress?.toDomain(),
            trackingNumbers: (successfulFulfillments ?? [])
                .flatMap { $0.trackingInfo }
                .compactMap { $0.number },
            lineItems: lineItems.nodes.map { $0.toDomain() }
        )
    }
}

extension StorefrontOrderAddress {
    func toDomain() -> OrderShippingAddress {
        OrderShippingAddress(
            name: name,
            address1: address1 ?? "",
            address2: address2,
            city: city ?? "",
            province: province,
            country: country ?? "",
            zip: zip ?? ""
        )
    }
}

extension StorefrontOrderLineItemDetail {
    func toDomain() -> OrderLineItemDetail {
        OrderLineItemDetail(
            title: title,
            quantity: quantity,
            variantTitle: variant?.title,
            imageURL: variant?.image?.url,
            price: variant?.price.amount
        )
    }
}
