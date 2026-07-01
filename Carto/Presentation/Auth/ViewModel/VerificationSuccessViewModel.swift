//
//  VerificationSuccessViewModel.swift
//  Carto
//
//  Created by automated edit on 01/07/2026.
//

import Foundation

@MainActor
final class VerificationSuccessViewModel: ObservableObject {

    private let router: AuthRouter
    private let authSession: AuthSession

    init(
        router: AuthRouter,
        authSession: AuthSession
    ) {
        self.router = router
        self.authSession = authSession
    }

    func onGetStartedClicked() async {
        _ = authSession.currentUser
    }
}
