import Foundation

final class AppContainer {

    // MARK: - Network
    let apiClient: ShopifyAPIClient

    let categoryRepository: CategoryRepositoryProtocol
    let orderRepository : OrderRepositoryProtocol

    init() {
        self.apiClient      = ShopifyAPIClient.shared
//        self.storageManager = StorageManager.shared

        self.categoryRepository = CategoryRepositoryImpl()
        self.orderRepository = OrderRepositoryImpl()
    }
}
