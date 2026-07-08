//
//  HeaderView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct HeaderView: View {

    @Environment(\.dismiss) private var dismiss

    let title: String

    var body: some View {
        HStack(spacing: 12) {

            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemBackground))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }

            Text(title)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.45)
                .allowsTightening(true)
                .frame(maxWidth: .infinity)

            Button {

            } label: {
                Image(systemName: "cart")
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color(.systemBackground))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }
        }
    }
}
