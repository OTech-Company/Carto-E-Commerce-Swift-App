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
    private let appViewModel: AppViewModel

    init(
        router: AuthRouter,
        appViewModel: AppViewModel
    ) {
        self.router = router
        self.appViewModel = appViewModel
    }

    func onGetStartedClicked() async {
        await appViewModel.restoreSession()
    }
}
