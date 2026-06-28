
struct PaymentMethodEntity {
    let id: String
    let type: PaymentType
    let last4: String?
    let brand: String?
}
enum PaymentType { case card, applePay, cashOnDelivery }

