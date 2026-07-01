// MARK: - Core Order Structures (REST Admin API Compliant)
struct OrderListResponse: Decodable {
    let orders: [OrderDTO]?
}

struct OrderDTO: Decodable { // Changed from Codable to Decodable
    let id: Int // Changed from String to Int to prevent REST type mismatch
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String           // paid, pending, refunded, unknown
    let fulfillmentStatus: String?        // fulfilled, unfulfilled, scheduled, etc.
    
    // Shopify REST Admin passes currency totals directly as flat price strings
    let totalPrice: String?
    let subtotalPrice: String?
    let totalDiscounts: String?
    let currency: String?                 // e.g., "USD"
    
    let discountApplications: [DiscountApplicationDTO]?
    let lineItems: [OrderLineItemDTO]?
    let shippingAddress: AddressDTO?
}

struct OrderLineItemDTO: Decodable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String? // Shopify REST returns variant cost as a string "price"
    let variantId: Int? // References the corresponding Variant identifier
    let sku: String?
}

struct DiscountApplicationDTO: Decodable {
    let type: String?
    let value: String?                     // Can be a percentage like "10.0" or a fixed price
    let valueType: String?                 // "percentage" or "fixed_amount"
    let code: String?
}

struct AddressDTO: Decodable {
    let id: Int? // Changed from String to Int
    let firstName: String?
    let lastName: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
}
