//
//  ProfileView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    Label("Profile", systemImage: "person.crop.circle")
                    Label("Addresses", systemImage: "house")
                }

                Section("App") {
                    Label("Notifications", systemImage: "bell")
                    Label("Language", systemImage: "globe")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

typealias ProfileView = SettingsView
