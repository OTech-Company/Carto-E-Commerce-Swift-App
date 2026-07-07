//
//  SettingsView.swift
//  Carto
//
//  Created by Nadin Ahmed on 07/07/2026.
//

import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        List {
            Section {
                Toggle(isOn: $viewModel.isDarkMode) {
                    Label(
                        "dark_mode",
                        systemImage: viewModel.isDarkMode
                            ? "moon.fill"
                            : "sun.max.fill"
                    )
                }
                .tint(Color("PrimaryColor"))
                .padding(.vertical, 4)
            } header: {
                Text("appearance_settings")
            }

            Section {
                Picker(selection: $viewModel.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                } label: {
                    Label("language_settings", systemImage: "globe")
                }
            } header: {
                Text("language_settings")
            }

            Section {
                Picker(selection: $viewModel.currency) {
                    ForEach(AppCurrency.allCases) { cur in
                        Text(cur.displayName).tag(cur)
                    }
                } label: {
                    Label("currency_settings", systemImage: "dollarsign.circle")
                }
            } header: {
                Text("currency_settings")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("settings_title")
        .id(viewModel.language)
    }
}
