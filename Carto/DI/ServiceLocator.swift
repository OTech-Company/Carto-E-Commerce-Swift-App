import Foundation

final class ServiceLocator {

    // MARK: - Singleton
    static let shared = ServiceLocator()
    private init() {}

    // MARK: - Container
    private var container: AppContainer?

    // MARK: - Setup — call once in CartoApp.swift
    func register(container: AppContainer) {
        self.container = container
    }

    func resolveCategoryRepository() -> CategoryRepositoryProtocol {
            guard let repo = container?.categoryRepository else {
                fatalError("AppContainer not registered. Call ServiceLocator.shared.register() first.")
            }
            return repo
        }
    func resolveOrderRepository() -> OrderRepositoryProtocol {
            guard let repo = container?.orderRepository else {
                fatalError("AppContainer not registered. Call ServiceLocator.shared.register() first.")
            }
            return repo
        }
//    // MARK: - Resolvers — one per repository
//    func resolveAuthRepository() -> AuthRepository {
//        guard let repo = container?.authRepository else {
//            fatalError("AppContainer not registered. Call ServiceLocator.shared.register() first.")
//        }
//        return repo
//    }


}
