struct OrderDTO: Codable {
    let id: String
    let orderNumber: Int
    let processedAt: String
    let financialStatus: String           // paid, pending, refunded, unknown
    let fulfillmentStatus: String?        // fulfilled, unfulfilled, scheduled, partial, unknown
    let currentTotalPrice: MoneyDTO       // CHANGED: was String, now Money
    let currentSubtotalPrice: MoneyDTO?   // NEW: before taxes/shipping
    let currentTotalDiscounts: MoneyDTO?  // NEW: total discount amount
    let discountApplications: [DiscountApplicationDTO]? // NEW: discount breakdown
    let lineItems: [OrderLineItemDTO]?
    let shippingAddress: AddressDTO?
}

struct OrderLineItemDTO: Codable {
    let title: String
    let quantity: Int
    let originalTotalPrice: MoneyDTO     // CHANGED: was price, now proper Money object
    let variant: VariantDTO?              // NEW: includes product details
}

struct DiscountApplicationDTO: Codable { // NEW: discount details on order
    let code: String?
    let value: DiscountValueDTO?
}

struct DiscountValueDTO: Codable {       // NEW: discount can be percentage or fixed amount
    let percentage: Double?
    let amount: MoneyDTO?
}

struct AddressDTO: Codable {
    let id: String?                       // NEW: address ID from Shopify
    let firstName: String?
    let lastName: String?
    let address1: String?
    let address2: String?                 // NEW: apartment/suite number
    let city: String?
    let province: String?                 // NEW: state/province
    let country: String?
    let zip: String?
    let phone: String?
}
