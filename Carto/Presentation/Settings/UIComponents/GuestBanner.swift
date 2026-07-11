//
//  GuestBanner.swift
//  Carto
//
//  Created by Nadin Ahmed on 07/07/2026.
//

import SwiftUI

struct GuestBanner: View {
    let onLogin: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("browsing_as_guest")
                .font(.headline)
                .foregroundStyle(.white)

            Text(
                "guest_banner_description"
            )
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.9))
            .fixedSize(horizontal: false, vertical: true)

            Button(action: onLogin) {
                Label("login_btn", systemImage: "arrow.right.circle.fill")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(.white)
                    .foregroundStyle(Color("PrimaryColor"))
                    .clipShape(Capsule())
            }
            .padding(.top, 6)
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [
                    Color("PrimaryColor"),
                    Color("PrimaryColor").opacity(0.8),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.12), radius: 8, y: 5)
        .padding(.horizontal)
    }
}
