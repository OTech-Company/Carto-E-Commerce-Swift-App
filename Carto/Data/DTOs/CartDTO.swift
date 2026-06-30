struct CartDTO: Codable {
    let id: String
    let checkoutUrl: String
    let totalQuantity: Int?               // NEW: total items in cart
    let discountCodes: [DiscountCodeDTO]? // NEW: applied discount codes
    let lines: [CartLineDTO]?
    let cost: CartCostDTO
}

struct CartLineDTO: Codable {
    let id: String
    let quantity: Int
    let cost: CartLineCostDTO?            // NEW: line-level costs
    let merchandise: VariantDTO?          // Product variant details
}

struct CartLineCostDTO: Codable {        // NEW: line-level pricing
    let totalAmount: MoneyDTO
    let amountPerQuantity: MoneyDTO?
    let compareAtAmountPerQuantity: MoneyDTO?
}

struct CartCostDTO: Codable {
    let subtotalAmount: MoneyDTO
    let totalAmount: MoneyDTO
    let totalTaxAmount: MoneyDTO?
    let checkoutChargeAmount: MoneyDTO?  // NEW: additional checkout charges if any
}

struct DiscountCodeDTO: Codable {       // NEW: discount information
    let code: String
    let applicable: Bool
}

struct MoneyDTO: Codable {
    let amount: String
    let currencyCode: String
}
