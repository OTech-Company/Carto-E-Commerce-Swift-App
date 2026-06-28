struct CartDTO: Codable {
    let id: String
    let checkoutUrl: String
    let lines: [CartLineDTO]
    let cost: CartCostDTO
}

struct CartLineDTO: Codable {
    let id: String
    let quantity: Int
    let merchandise: VariantDTO
}

struct CartCostDTO: Codable {
    let totalAmount: MoneyDTO
    let subtotalAmount: MoneyDTO
    let totalTaxAmount: MoneyDTO?
}

struct MoneyDTO: Codable {
    let amount: String
    let currencyCode: String
}
