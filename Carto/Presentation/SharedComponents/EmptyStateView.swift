//
//  EmptyStateView.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct EmptyStateView: View {
    let image: String
    let title: String
    var isSystemImage: Bool = true

    var body: some View {
        VStack(spacing: 16) {
            if isSystemImage {
                Image(systemName: image)
                    .font(.system(size: 60))
                    .foregroundStyle(.secondary)
            } else {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.secondary)
            }

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
