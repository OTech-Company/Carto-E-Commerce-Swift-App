struct PaymentDTO: Codable {
    let id: String
    let amount: String
    let currencyCode: String
    let paymentGateway: String?  // shopify_payments, apple_pay, etc.
    let status: String           // pending, success, failure
    let errorMessage: String?
}

struct PaymentMethodDTO: Codable {
    let id: String
    let type: String             // card, apple_pay, cash_on_delivery
    let last4: String?
    let brand: String?
}
