import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()

    let authRepository: AuthenticationRepositoryProtocol
    
    let validator: AuthValidatorProtocol

    let appViewModel: AppViewModel

    private init() {
        authRepository = AuthenticationRepositoryImpl()
        
        validator = AuthValidatorImpl()

        appViewModel = AppViewModel(
            repository: authRepository
        )
    }

    func makeLoginViewModel(router: AuthRouter) -> AuthLoginViewModel {
        AuthLoginViewModel(
            validator: validator,
            repository: authRepository,
            appViewModel: appViewModel,
            router: router
        )
    }
    
    func makeRegisterViewModel(router: AuthRouter) -> AuthRegisterViewModel {
        AuthRegisterViewModel(
            validator: validator,
            repository: authRepository,
            appViewModel: appViewModel,
            router: router
        )
    }

    func makeVerificationViewModel(userEmail: String, router: AuthRouter) -> VerificationViewModel {
        VerificationViewModel(
            userEmail: userEmail,
            repository: authRepository,
            appViewModel: appViewModel,
            router: router
        )
    }

    func makeVerificationSuccessViewModel(router: AuthRouter) -> VerificationSuccessViewModel {
        VerificationSuccessViewModel(
            router: router,
            appViewModel: appViewModel
        )
    }
}
