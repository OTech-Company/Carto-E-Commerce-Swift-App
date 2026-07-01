//
//  ForgotPasswordSuccessViewModel.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import Foundation

@MainActor
final class ForgotPasswordSuccessViewModel: ObservableObject {

    private let router: AuthRouter

    init(router: AuthRouter) {
        self.router = router
    }

    func backToSignIn() {
        router.showLogin()
    }
}
