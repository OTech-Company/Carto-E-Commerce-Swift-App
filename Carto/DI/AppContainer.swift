import Foundation

final class AppContainer {

    // MARK: - Network
    let apiClient: ShopifyAPIClient

//    // MARK: - Storage
//    let storageManager: StorageManager

//    // MARK: - Repositories — one per feature
//    let authRepository: AuthRepository
//    let productRepository: ProductRepository
//    let brandRepository: BrandRepository
//    let categoryRepository: CategoryRepository
//    let cartRepository: CartRepository
//    let orderRepository: OrderRepository
//    let favoritesRepository: FavoritesRepository
//    let searchRepository: SearchRepository
//    let couponRepository: CouponRepository
//    let paymentRepository: PaymentRepository
//    let adsRepository: AdsRepository
//    let settingsRepository: SettingsRepository

    init() {
        self.apiClient      = ShopifyAPIClient.shared
//        self.storageManager = StorageManager.shared

//        // 2. Repositories — inject apiClient + storageManager into each
//        self.authRepository     = AuthRepository(apiClient: apiClient)
//        self.productRepository  = ProductRepository(apiClient: apiClient)
//        self.brandRepository    = BrandRepository(apiClient: apiClient)
//        self.categoryRepository = CategoryRepository(apiClient: apiClient)
//        self.cartRepository     = CartRepository(apiClient: apiClient, storage: storageManager)
//        self.orderRepository    = OrderRepository(apiClient: apiClient)
//        self.favoritesRepository = FavoritesRepository(storage: storageManager)
//        self.searchRepository   = SearchRepository(apiClient: apiClient)
//        self.couponRepository   = CouponRepository(apiClient: apiClient)
//        self.paymentRepository  = PaymentRepository(apiClient: apiClient)
//        self.adsRepository      = AdsRepository(apiClient: apiClient)
//        self.settingsRepository = SettingsRepository(storage: storageManager)
    }
}
