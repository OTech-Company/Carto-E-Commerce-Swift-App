//
//  CartoApp.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import SwiftUI
import Firebase

@main
struct CartoApp: App {

    @StateObject private var appViewModel: AppViewModel

    init() {
        FirebaseApp.configure()

        let container = AppContainer()
        ServiceLocator.shared.register(container: container)

        _appViewModel = StateObject(
            wrappedValue: AppViewModel(repository: ServiceLocator.shared.resolveAuthRepository())
        )
    }

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: AuthLoginViewModel(validator: AuthValidator(),repository: ServiceLocator.shared.resolveAuthRepository(),appViewModel: appViewModel))
                .environmentObject(appViewModel)
        }
    }
}
