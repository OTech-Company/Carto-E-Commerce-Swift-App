import Foundation
struct ShippingTrackingEntity {
    let orderId: String
    let carrier: String
    let trackingNumber: String
    let trackingUrl: String?
    let estimatedDelivery: Date?
    let currentStatus: String
}

