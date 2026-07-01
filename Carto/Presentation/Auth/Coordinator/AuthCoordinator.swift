//
//  AuthCoordinator.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import SwiftUI

import SwiftUI

struct AuthCoordinator: View {

    let container: DIContainer

    @StateObject private var router = AuthRouter()

    var body: some View {

        NavigationStack(path: $router.path) {

            LoginView(
                viewModel: container.makeLoginViewModel(router: router)
            )
            .navigationDestination(for: AuthRoute.self) { route in

                switch route {

                case .login:
                    LoginView(
                        viewModel: container.makeLoginViewModel(router: router)
                    )

                case .register:
                    RegisterView(
                        viewModel: container.makeRegisterViewModel(router: router)
                    )

                case .verification(let email):
                    VerificationView(
                        viewModel: container.makeVerificationViewModel(
                            userEmail: email,
                            router: router
                        )
                    )

                case .verificationSuccess:
                    VerificationSuccessView(
                        viewModel: container.makeVerificationSuccessViewModel(router: router)
                    )

                case .forgotPassword:
                    ForgotPasswordView(
                        viewModel: container.makeForgotPasswordViewModel(router: router)
                    )

                case .forgotPasswordSuccess:
                    ForgotPasswordSuccessView(
                        viewModel: container.makeForgotPasswordSuccessViewModel(router: router)
                    )
                }
            }
        }
        .environmentObject(router)
    }
}
