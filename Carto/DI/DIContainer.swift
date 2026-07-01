//
//  DIContainer.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

@MainActor
final class DIContainer {
    static let shared = DIContainer()

    let authRepository: AuthenticationRepositoryProtocol
    let authSession: AuthSession
    let validator: AuthValidatorProtocol
    let appViewModel: AppViewModel

    private init() {
        authRepository = AuthenticationRepositoryImpl()
        authSession = AuthSession()
        validator = AuthValidatorImpl()
        appViewModel = AppViewModel(authSession: authSession)
    }

    func makeLoginViewModel(router: AuthRouter) -> AuthLoginViewModel {
        AuthLoginViewModel(
            validator: validator,
            repository: authRepository,
            authSession: authSession,
            router: router
        )
    }
    
    func makeRegisterViewModel(router: AuthRouter) -> AuthRegisterViewModel {
        AuthRegisterViewModel(
            validator: validator,
            repository: authRepository,
            authSession: authSession,
            router: router
        )
    }

    func makeVerificationViewModel(userEmail: String, router: AuthRouter) -> VerificationViewModel {
        VerificationViewModel(
            userEmail: userEmail,
            repository: authRepository,
            authSession: authSession,
            router: router
        )
    }

    func makeForgotPasswordViewModel(router: AuthRouter) -> ForgotPasswordViewModel {
        ForgotPasswordViewModel(
            validator: validator,
            repository: authRepository,
            router: router
        )
    }
}
