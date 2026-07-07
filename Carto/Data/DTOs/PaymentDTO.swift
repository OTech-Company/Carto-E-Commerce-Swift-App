struct PaymentDTO: Codable {
    let id: String
    let amount: String
    let currencyCode: String
    let paymentGateway: String?
    let status: String
    let errorMessage: String?
}

struct PaymentMethodDTO: Codable {
    let id: String
    let type: String
    let last4: String?
    let brand: String?
}
