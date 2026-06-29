import Foundation
struct OrderEntity {
    let id: String
    let orderNumber: Int
    let status: OrderStatus
    let items: [CartItemEntity]
    let total: Double
    let currency: String
    let shippingAddress: AddressEntity
    let placedAt: Date
}

enum OrderStatus {
    case pending, confirmed, shipped, delivered, cancelled, refunded
}


