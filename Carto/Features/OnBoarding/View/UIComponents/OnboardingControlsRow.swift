//
//  OnboardingControlsRow.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//


import SwiftUI

struct OnboardingControlsRow: View {

    let currentIndex: Int
    let totalPages: Int
    let textVisible: Bool
    let onNext: () -> Void

    var body: some View {
        HStack {
            // Dot indicators
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { i in
                    Capsule()
                        .fill(.white.opacity(i == currentIndex ? 1 : 0.35))
                        .frame(width: i == currentIndex ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.4), value: currentIndex)
                }
            }

            Spacer()

            // Next / Get Started button
            Button(action: onNext) {
                Text(currentIndex == totalPages - 1 ? "Get Started" : "Next")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(
                        width: currentIndex == totalPages - 1 ? 160 : 110,
                        height: 54
                    )
                    .background(.white)
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.4), value: currentIndex)
            }
        }
        .offset(y: textVisible ? 0 : 24)
        .opacity(textVisible ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.35), value: textVisible)
    }
}