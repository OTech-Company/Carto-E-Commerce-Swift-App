//
//  settings.ProfileView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import Combine
import SwiftUI

struct ProfileView: View {

    @State private var currentUser: User?
    @EnvironmentObject private var router: Router<AppRoute>
    @StateObject private var viewModel = DIContainer.shared
        .makeProfileViewModel()

    private var isAuthenticated: Bool {
        AuthSession.shared.sessionState.isAuthenticated
    }

    var body: some View {
        VStack(spacing: 0) {
            if !isAuthenticated {
                GuestBanner {
                    Task {
                        await viewModel.login()
                    }
                }.padding(.top)
            }

            List {
                if isAuthenticated {
                    userInfoSection
                    activitySection
                }
                appSettingsSection
                otherSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("profile_title")
        }
        .onAppear {
            currentUser = AuthSession.shared.currentUser
        }
        .onReceive(AuthSession.shared.sessionPublisher) {
            state in
            currentUser = state.user
        }
    }

    // MARK: - Sections
    
    @ViewBuilder
    private var userInfoSection: some View {
        Section {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color("PrimaryColor").opacity(0.12))
                        .frame(width: 56, height: 56)

                    Text(avatarInitials)
                        .font(.title3.bold())
                        .foregroundColor(Color("PrimaryColor"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(currentUser?.fullName ?? "Guest")
                        .font(.headline)

                    Text(currentUser?.email ?? "Not signed in")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.vertical, 6)
        }
    }

    @ViewBuilder
    private var activitySection: some View {
        Section("Activity") {
            Label("order_history_title", systemImage: "clock.arrow.circlepath")
                .onTapGesture {
                    router.push(to: .orderHistory)
                }
            Label("addresses_title", systemImage: "mappin.and.ellipse")
                .onTapGesture {
                    router.push(to: .addresses)
                }
        }
    }

    @ViewBuilder
    private var appSettingsSection: some View {
        Section("App") {
            Label("settings_title", systemImage: "gearshape")
                .onTapGesture {
                    router.push(to: .settings)
                }
        }
    }

    @ViewBuilder
    private var otherSection: some View {
        Section("Other") {
            Label("about_us_title", systemImage: "info.circle")
                .onTapGesture {
                    router.push(to: .aboutUs)
                }

            if isAuthenticated {
                Button(role: .destructive) {
                    Task {
                        await viewModel.signOut()
                    }
                } label: {
                    Label(
                        "log_out",
                        systemImage: "rectangle.portrait.and.arrow.right"
                    )
                }
            }
        }
    }

    // MARK: - Helpers

    private var avatarInitials: String {
        guard let user = currentUser else { return "G" }
        let first = user.firstName.prefix(1)
        let last = user.lastName.prefix(1)
        return "\(first)\(last)".uppercased()
    }
}
