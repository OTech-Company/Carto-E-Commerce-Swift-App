import Foundation

enum AppRoute: Hashable, Identifiable {
    case brands
    case brandProducts(brandId: Int, brandName: String)
    case categoryProducts(categoryId: String, categoryName: String)
    case productDetails(product: Product)

    var id: String {
        switch self {
        case .brands:
            return "brands"
        case .brandProducts(let brandId, _):
            return "brandProducts-\(brandId)"
        case .categoryProducts(let categoryId, _):
            return "categoryProducts-\(categoryId)"
        case .productDetails(let product):
            return "productDetails-\(product.id)"
        }
    }
}
