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
                        "Dark Mode",
                        systemImage: viewModel.isDarkMode
                            ? "moon.fill"
                            : "sun.max.fill"
                    )
                }
                .tint(Color("PrimaryColor"))
                .padding(.vertical, 4)
            } header: {
                Text("Appearance")
            }

            Section {
                Picker(selection: $viewModel.language) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                } label: {
                    Label("Language", systemImage: "globe")
                }
            } header: {
                Text("Language")
            }

            Section {
                Picker(selection: $viewModel.currency) {
                    ForEach(AppCurrency.allCases) { cur in
                        Text(cur.displayName).tag(cur)
                    }
                } label: {
                    Label("Currency", systemImage: "dollarsign.circle")
                }
            } header: {
                Text("Currency")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .id(viewModel.language)
    }
}
