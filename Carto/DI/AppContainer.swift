import Foundation

final class AppContainer {

    // MARK: - Network
    let apiClient: ShopifyAPIClient
    let authRepository: AuthenticationRepositoryProtocol
    init() {
        self.apiClient      = ShopifyAPIClient.shared
        self.authRepository = AuthenticationRepositoryImpl()
    }
}
