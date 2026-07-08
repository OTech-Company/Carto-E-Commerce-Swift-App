//
//  EmptyCartView.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import SwiftUI

struct EmptyCartView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {

            Image("emptyCart")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .background(.white)

            VStack {

                Spacer()

                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bag")

                        Text("Start Shopping")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.orange)
                    .frame(width: 220, height: 48)
                    .background(
                        LinearGradient(
                            colors: [
                                .white,
                                Color.orange.opacity(0.18)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay {
                        Capsule()
                            .stroke(
                                Color.orange.opacity(0.25),
                                lineWidth: 1
                            )
                    }
                    .clipShape(Capsule())
                    .shadow(
                        color: .orange.opacity(0.18),
                        radius: 10,
                        y: 6
                    )
                }

                Spacer()
                    .frame(height: 90)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}
