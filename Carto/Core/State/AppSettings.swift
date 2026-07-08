//
//  AppSettings.swift
//  Carto
//
//  Created by AI Agent.
//

import Foundation

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
    
    var languageCode: String {
        switch self {
        case .english: return "EN"
        case .arabic: return "AR"
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
    
    var countryCode: String {
        switch self {
        case .dollar: return "US"
        case .egyptianPound: return "EG"
        }
    }
    
    var exchangeRate: Double {
        switch self {
        case .dollar: return 1.0
        case .egyptianPound: return 50.0 
        }
    }
    
    func convert(price: Double) -> Double {
        return price * exchangeRate
    }
    
    func format(price: Double) -> String {
        let converted = convert(price: price)
        return String(format: "\(symbol) %.2f", converted)
    }
}

struct AppSettings {
    static let shared = AppSettings()
    
    var currentLanguageCode: String {
        let savedRawValue = UserDefaults.standard.string(forKey: "app_language") ?? AppLanguage.english.rawValue
        let appLanguage = AppLanguage(rawValue: savedRawValue) ?? .english
        return appLanguage.languageCode
    }
    
    var currentCountryCode: String {
        let savedRawValue = UserDefaults.standard.string(forKey: "app_currency") ?? AppCurrency.egyptianPound.rawValue
        let appCurrency = AppCurrency(rawValue: savedRawValue) ?? .egyptianPound
        return appCurrency.countryCode
    }
}
