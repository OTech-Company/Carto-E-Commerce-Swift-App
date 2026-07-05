//
//  ProfileView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var router: Router<AppRoute>

    var body: some View {
        List {
            Section("Account") {
                Label("Profile", systemImage: "person.crop.circle")
                Label("Addresses", systemImage: "house")
                    .onTapGesture {
                        router.push(to: .addresses)
                    }
            }

            Section("App") {
                Label("Notifications", systemImage: "bell")
                Label("Language", systemImage: "globe")
            }
        }
        .navigationTitle("Settings")
    }
}
