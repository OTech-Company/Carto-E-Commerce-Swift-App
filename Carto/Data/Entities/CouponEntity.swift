import Foundation
struct CouponEntity {
    let code: String
    let discountType: DiscountType
    let value: Double
    let expiresAt: Date?
    let isValid: Bool
}
enum DiscountType { case percentage, fixedAmount, freeShipping }

