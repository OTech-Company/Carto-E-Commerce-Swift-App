//
//  ProfileView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI
import Combine

struct ProfileView: View {

    @State private var currentUser: User?

    private var isAuthenticated: Bool {
        currentUser != nil
    }

    var body: some View {
        NavigationStack {
            List {
                userInfoSection
                activitySection
                appSettingsSection
                otherSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .onAppear {
                currentUser = DIContainer.shared.authSession.currentUser
            }
            .onReceive(DIContainer.shared.authSession.sessionPublisher) { state in
                currentUser = state.user
            }
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
            Label("Order History", systemImage: "clock.arrow.circlepath")
            Label("Addresses", systemImage: "mappin.and.ellipse")
        }
    }

    @ViewBuilder
    private var appSettingsSection: some View {
        Section("App") {
            Label("Settings", systemImage: "gearshape")
        }
    }

    @ViewBuilder
    private var otherSection: some View {
        Section("Other") {
            Label("About Us", systemImage: "info.circle")

            if isAuthenticated {
                Button(role: .destructive) {
                    signOut()
                } label: {
                    Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }

    // MARK: - Helpers

    private var avatarInitials: String {
        guard let user = currentUser else { return "G" }
        let first = user.firstName.prefix(1)
        let last  = user.lastName.prefix(1)
        return "\(first)\(last)".uppercased()
    }

    private func signOut() {
        DIContainer.shared.authRepository.signOut()
    }
}

