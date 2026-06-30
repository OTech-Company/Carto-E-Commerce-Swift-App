import Foundation

// MARK: - Core Order DTO structures (No explicit CodingKeys)
struct OrderDTO: Decodable {
    let id: Int
    let orderNumber: Int         // Decodes from "order_number" automatically
    let processedAt: String?     // Decodes from "processed_at" automatically
    let financialStatus: String?  // Decodes from "financial_status" automatically
    let fulfillmentStatus: String?// Decodes from "fulfillment_status" automatically
    let totalPrice: String?      // Decodes from "total_price" automatically
    let subtotalPrice: String?   // Decodes from "subtotal_price" automatically
    let totalDiscounts: String?  // Decodes from "total_discounts" automatically
    let currency: String?
    let discountApplications: [DiscountApplicationDTO]? // Decodes from "discount_applications"
    let lineItems: [OrderLineItemDTO]?                  // Decodes from "line_items"
    let shippingAddress: AddressDTO?                    // Decodes from "shipping_address"
}

struct OrderLineItemDTO: Decodable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String?
    let variantId: Int?          // Decodes from "variant_id" automatically
    let sku: String?
}

struct DiscountApplicationDTO: Decodable {
    let type: String?
    let value: String?
    let valueType: String?       // Decodes from "value_type" automatically
    let code: String?
}

struct AddressDTO: Decodable {
    let id: Int?
    let firstName: String?       // Decodes from "first_name" automatically
    let lastName: String?        // Decodes from "last_name" automatically
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
}
