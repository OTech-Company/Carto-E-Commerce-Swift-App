//
//  CartoApp.swift
//  Carto
//

import SwiftUI
import FirebaseCore

@main
struct CartoApp: App {
    @StateObject private var appViewModel: AppViewModel
    
    init() {
        URLCache.shared = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "image_cache"
         )
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        ServiceLocator.shared.register(container: AppContainer())
        _appViewModel = StateObject(wrappedValue: DIContainer.shared.appViewModel)
    }
        
    
    var body: some Scene {
        WindowGroup {
            switch appViewModel.sessionState {
            case .loading:
                SplashView()
            case .unauthenticated:
                PaymentDemoView()
            case .guest:
                PaymentDemoView()
            case .authenticated(let user):
                if user.isEmailVerified {
                    PaymentDemoView()
                } else {
                    Text("Carto requires iOS 17 or later.")
                }
            }
        }
    }
}
