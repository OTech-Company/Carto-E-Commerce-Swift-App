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
        ServiceLocator.shared.register(container: AppContainer())
        let container = DIContainer.shared
        _appViewModel = StateObject(wrappedValue: container.appViewModel)
    }

    var body: some Scene {
        WindowGroup {
            switch appViewModel.sessionState {
                
            case .loading:
                SplashView()

            case .unauthenticated:
                AuthCoordinator(container: DIContainer.shared)

            case .guest,
                 .authenticated:
                MainView()
            }
        }
    }
}
