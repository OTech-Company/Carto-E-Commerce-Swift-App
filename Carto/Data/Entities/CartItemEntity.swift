import Foundation
struct CartItemEntity {
    let id: String
    let product: ProductEntity
    let selectedVariant: VariantEntity
    var quantity: Int
    let addedAt: Date
}

