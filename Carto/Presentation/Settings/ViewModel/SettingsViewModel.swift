//
//  SettingsViewModel.swift
//  Carto
//
//  Created by Nadin Ahmed on 07/07/2026.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("app_theme_is_dark") var isDarkMode: Bool = false
    @AppStorage("app_language") var language: AppLanguage = .english
    @AppStorage("app_currency") var currency: AppCurrency = .egyptianPound
}
