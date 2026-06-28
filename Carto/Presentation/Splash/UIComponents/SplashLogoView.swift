//
//  SplashLogoView.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//

import SwiftUI

struct SplashLogoView: View {
    let visible: Bool

    var body: some View {
        Image("app_logo")
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .scaleEffect(visible ? 1 : 0.7)
            .opacity(visible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: visible)
    }
}

