struct OrderDTO: Codable {
    let id: String
    let orderNumber: Int
    let financialStatus: String   // paid, pending, refunded
    let fulfillmentStatus: String? // fulfilled, unfulfilled
    let totalPrice: String
    let lineItems: [OrderLineItemDTO]
    let shippingAddress: AddressDTO?
    let processedAt: String
}

struct OrderLineItemDTO: Codable {
    let title: String
    let quantity: Int
    let price: String
    let variantTitle: String?
}

struct AddressDTO: Codable {
    let firstName: String?
    let lastName: String?
    let address1: String?
    let city: String?
    let country: String?
    let zip: String?
    let phone: String?
}
