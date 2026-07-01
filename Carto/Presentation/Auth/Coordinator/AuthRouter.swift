//
//  AuthRouter.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import SwiftUI

@MainActor
final class AuthRouter: ObservableObject {

    @Published var path = NavigationPath()

    func push(_ route: AuthRoute) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

extension AuthRouter {

    func showLogin() {
        popToRoot()
    }

    func showRegister() {
        push(.register)
    }

    func showVerification(email: String) {
        push(.verification(email: email))
    }

    func showVerificationSuccess() {
        push(.verificationSuccess)
    }
}
