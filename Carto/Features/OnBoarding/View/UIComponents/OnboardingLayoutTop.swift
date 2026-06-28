//
//  OnboardingLayoutTop.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//


import SwiftUI

// Layout for bag page — image drops from top, text below
struct OnboardingLayoutTop: View {

    let page: OnboardingPage
    let imageVisible: Bool
    let textVisible: Bool
    let currentIndex: Int
    let totalPages: Int
    let onNext: () -> Void

    private let screen = UIScreen.main.bounds

    var body: some View {
        VStack(spacing: 0) {

            // Image enters from top
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: screen.width, height: screen.height * 0.50)
                .clipped()
                .offset(y: imageVisible ? 0 : -screen.height * 0.55)
                .opacity(imageVisible ? 1 : 0)
                .animation(.spring(response: 0.65, dampingFraction: 0.78), value: imageVisible)

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                OnboardingHeadlineBlock(page: page, textVisible: textVisible)
                Spacer()
                OnboardingControlsRow(
                    currentIndex: currentIndex,
                    totalPages: totalPages,
                    textVisible: textVisible,
                    onNext: onNext
                )
                Spacer().frame(height: 36)
            }
            .padding(.horizontal, 28)
            .frame(width: screen.width, height: screen.height * 0.50)
        }
    }
}