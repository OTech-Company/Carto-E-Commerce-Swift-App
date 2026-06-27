struct CouponDTO: Codable {
    let id: String
    let code: String
    let discountType: String    // percentage, fixed_amount, free_shipping
    let value: Double
    let startsAt: String?
    let endsAt: String?
    let usageLimit: Int?
    let timesUsed: Int?
}
