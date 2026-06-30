import Foundation

// DI/ServiceLocator.swift
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

    // MARK: - Resolvers — one per repository
    func resolveAuthRepository() -> AuthenticationRepositoryProtocol {
        guard let repo = container?.authRepository else {
            fatalError("AppContainer not registered. Call ServiceLocator.shared.register() first.")
        }
        return repo
    }
}
