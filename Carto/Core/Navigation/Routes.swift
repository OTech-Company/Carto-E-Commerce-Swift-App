import Foundation

enum AppRoute: Hashable, Identifiable {
    case addresses
    case brands
    case brandProducts(brandId: Int, brandName: String)
    case categoryProducts(categoryId: String, categoryName: String)
    case productDetails(product: Product)
    case aiChat
    case aiComparison
    case aiOutfit
    var id: String {
        switch self {
        case .addresses:
            return "addresses"
        case .brands:
            return "brands"
        case .brandProducts(let brandId, _):
            return "brandProducts-\(brandId)"
        case .categoryProducts(let categoryId, _):
            return "categoryProducts-\(categoryId)"
        case .productDetails(let product):
            return "productDetails-\(product.id)"
        case .aiChat:
            return "aiChat"
        case .aiComparison:
            return "aiComparison"
        case .aiOutfit :
            return "aiOutfit"
        }
    }
}
