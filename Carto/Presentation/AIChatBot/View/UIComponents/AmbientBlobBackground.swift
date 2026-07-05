//
//  AmbientBlobBackground.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//


//
//  AmbientBlobBackground.swift
//  Carto
//

import SwiftUI

struct AmbientBlobBackground: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            
            // Premium ambient glows matching Carto design layout
            RadialGradient(colors: [Color.blue.opacity(0.18), .clear], center: .bottomTrailing, startRadius: 10, endRadius: 300)
            RadialGradient(colors: [Color.cyan.opacity(0.15), .clear], center: .topLeading, startRadius: 10, endRadius: 250)
            RadialGradient(colors: [Color.blue.opacity(0.12), .clear], center: .center, startRadius: 10, endRadius: 200)
        }
        .ignoresSafeArea()
    }
}

// Glassmorphic helper modifier required for custom subviews
struct GlassCardModifier: ViewModifier {
    var cornerRadius: CGFloat
    var isEnabled: Bool
    
    func body(content: Content) -> some View {
        if isEnabled {
            content
                .background(.ultraThinMaterial.opacity(0.8))
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        } else {
            content
        }
    }
}

extension View {
    func glassCardStyle(cornerRadius: CGFloat = 16, isEnabled: Bool = true) -> some View {
        self.modifier(GlassCardModifier(cornerRadius: cornerRadius, isEnabled: isEnabled))
    }
}