//
//  SettingsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 07/07/2026.
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }
}

enum AppCurrency: String, CaseIterable, Identifiable {
    case dollar = "USD"
    case egyptianPound = "EGP"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .dollar: return "USD"
        case .egyptianPound: return "EGP"
        }
    }

    var symbol: String {
        switch self {
        case .dollar: return "$"
        case .egyptianPound: return "E£"
        }
    }
}

class SettingsViewModel: ObservableObject {

    @AppStorage("app_theme_is_dark") var isDarkMode: Bool = false
    @AppStorage("app_language") var language: AppLanguage = .english
    @AppStorage("app_currency") var currency: AppCurrency = .egyptianPound
}
