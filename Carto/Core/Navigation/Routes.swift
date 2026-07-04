import Foundation

enum AppRoute: Hashable {
    // Product exploration paths
    case productDetails(id: String, name: String)
    case categoryListing(categoryName: String)
    
    case cartPreview
    case secureCheckout
    case orderDetails(orderId: String)
    
    // Account & profile settings
    case addressBook
    case editProfile
}
