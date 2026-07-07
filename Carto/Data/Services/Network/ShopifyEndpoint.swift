import Foundation

enum ShopifyEndpoint: Sendable {

    // Auth
    case login
    case register
    case logout
    case updateCustomer(id: String)

    // Products
    case products
    case productDetail(id: String)
    case productsByCategory(id: String)
    case productsByBrand(id: String)

    // Categories & Brands
    case categories
    case brands

    // Search
    case search(query: String)

    // Cart
    case createCart
    case addToCart(cartId: String)
    case removeFromCart(cartId: String, lineId: String)

    // Orders
    case orders
    case orderDetail(id: String)

    // Coupons
    case validateCoupon(code: String)

    // Payment
    case checkout
    case paymentMethods

    // Ads / Banners
    case banners

    // Address
    case addresses(customerId: String)
    case addressByID(id: String, customerId: String)
    case addAddress(customerId: String)
    case updateAddress(id: String, customerId: String)
    case setDefaultAddress(customerId: String, addressId: String)
    case deleteAddress(id: String, customerId: String)

    // Computed path for each case
    var path: String {
        switch self {
        case .login:                          return "/account/login"
        case .register:                       return "/account/register"
        case .logout:                         return "/account/logout"
        case .updateCustomer(let id):         return "/customers/\(id).json"
        case .products:                       return "/products.json"
        case .productDetail(let id):          return "/products/\(id).json"
        case .productsByCategory(let id):    return "/collections/\(id)/products.json"
        case .productsByBrand(let id):       return "/collections/\(id)/products.json"
        case .categories:                     return "/custom_collections.json"
        case .brands:                         return "/smart_collections.json"
        case .search(let q):                 return "/search.json?q=\(q)"
        case .createCart:                     return "/cart/graphql"
        case .addToCart(let id):             return "/cart/\(id)/lines/add"
        case .removeFromCart(let cId, _):    return "/cart/\(cId)/lines/remove"
        case .orders:                         return "/orders.json"
        case .orderDetail(let id):           return "/orders/\(id).json"
        case .validateCoupon(let code):      return "/discount_codes/\(code).json"
        case .checkout:                       return "/checkouts.json"
        case .paymentMethods:                 return "/payment_methods.json"
        case .banners:                        return "/metafields.json"
        case .addresses(let customerId):
            return "/customers/\(customerId)/addresses.json"
        case .addressByID(let id, let customerId):
            return "/customers/\(customerId)/addresses/\(id).json"
        case .addAddress(let customerId):
            return "/customers/\(customerId)/addresses.json"
        case .updateAddress(let id, let customerId):
            return "/customers/\(customerId)/addresses/\(id).json"
        case .setDefaultAddress(let customerId, let addressId):
            return
                "/customers/\(customerId)/addresses/\(addressId)/default.json"
        case .deleteAddress(let id, let customerId):
            return "/customers/\(customerId)/addresses/\(id).json"

        }
    }

    var httpMethod: String {
        switch self {
        case .login, .register, .createCart,
            .addToCart, .checkout, .addAddress:
            return "POST"
        case .removeFromCart, .deleteAddress:
            return "DELETE"
        case .updateAddress, .setDefaultAddress, .updateCustomer:
            return "PUT"
        default: return "GET"
        }
    }
}
