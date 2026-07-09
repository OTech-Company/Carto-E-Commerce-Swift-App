//
//  CartoApp.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import SwiftUI
import FirebaseCore

@main
struct CartoApp: App {
    @StateObject private var appViewModel: AppViewModel
    // 1. Declare the CartViewModel as a StateObject
    @StateObject private var cartViewModel: CartViewModel
    
    @AppStorage("app_theme_is_dark") private var isDarkMode: Bool = false
    @AppStorage("app_language") private var language: AppLanguage = .english
    @AppStorage("app_currency") private var currency: AppCurrency = .egyptianPound
    
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

        // Resolve both ViewModels cleanly from your Shared DI Container
        _appViewModel = StateObject(wrappedValue: DIContainer.shared.appViewModel)
        _cartViewModel = StateObject(wrappedValue: DIContainer.shared.sharedCartViewModel)
    }
        
    var body: some Scene {
        WindowGroup {
            Group {
                switch appViewModel.sessionState {
                case .loading:
                    SplashView()
                case .onboarding:
                    OnboardingScreen(onGetStarted: {
                        appViewModel.completeOnboarding()
                    })
                case .unauthenticated:
                    AuthCoordinator(container: DIContainer.shared)
                case .guest:
                    ContentView()
                case .authenticated(let user):
                    if user.isEmailVerified {
                        ContentView()
                    } else {
                        AuthCoordinator(container: DIContainer.shared)
                    }
                }
            }
            // 2. Inject the CartViewModel into the environment for all states to inherit
            .environmentObject(cartViewModel)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environment(\.locale, Locale(identifier: language.rawValue))
            .environment(\.layoutDirection, language == .arabic ? .rightToLeft : .leftToRight)
            .id(language)
        }
    }
}
