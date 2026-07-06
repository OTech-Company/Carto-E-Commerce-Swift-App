import Foundation


struct OrdersResponse: Decodable {
    let orders: [OrderDTO]?
}

// MARK: - Core Order DTO structures (No explicit CodingKeys)
struct OrderDTO: Decodable {
    let id: Int
    let orderNumber: Int
    let processedAt: String?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalPrice: String?
    let subtotalPrice: String?
    let totalDiscounts: String?
    let currency: String?
    let discountApplications: [DiscountApplicationDTO]?
    let lineItems: [OrderLineItemDTO]?
    let shippingAddress: AddressDTO?
}

struct OrderLineItemDTO: Decodable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String?
    let variantId: Int?
    let sku: String?
}

struct DiscountApplicationDTO: Decodable {
    let type: String?
    let value: String?
    let valueType: String?
    let code: String?
}
