//
//  CartoApp.swift
//  Carto
//

import SwiftUI
import FirebaseCore

@main
struct CartoApp: App {
    @StateObject private var appViewModel: AppViewModel
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

        _appViewModel = StateObject(wrappedValue: DIContainer.shared.appViewModel)
    }
        
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appViewModel.sessionState {
                case .loading:
                    SplashView()
                case .unauthenticated:
                    AuthCoordinator(container: DIContainer.shared)
                case .guest:
                    ContentView()
                case .authenticated(let user):
                    if user.isEmailVerified {
                        ContentView()
                    } else {
                        ContentView()
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environment(\.locale, Locale(identifier: language.rawValue))
            .environment(\.layoutDirection, language == .arabic ? .rightToLeft : .leftToRight)
            .id(language)
        }
    }
}
