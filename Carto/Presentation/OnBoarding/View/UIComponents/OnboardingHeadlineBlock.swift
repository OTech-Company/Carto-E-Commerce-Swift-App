//
//  OnboardingHeadlineBlock.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//


import SwiftUI

struct OnboardingHeadlineBlock: View {

    let page: OnboardingPage
    let textVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(page.outlinedText, id: \.self) { line in
                OutlinedText(text: line, fontSize: 44)
            }
            Text(page.boldText)
                .font(.system(size: 44, weight: .black))
                .foregroundStyle(.white)
                .padding(.top, 6)
        }
        .offset(y: textVisible ? 0 : 24)
        .opacity(textVisible ? 1 : 0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.2), value: textVisible)
    }
}