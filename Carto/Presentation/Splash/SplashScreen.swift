//
//  SplashScreen.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SwiftUI
import SpriteKit


// MARK: - Main Splash View
struct SplashView: View {
    @State private var logoVisible = false
    @State private var scene = SplashPhysicsScene()
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                SpriteView(scene: scene, options: [.allowsTransparency])
                    .ignoresSafeArea()
                    .onAppear {
                        scene.safeAreaInsets = geometry.safeAreaInsets
                    }
                
                // Static Logo Overlay without physics
                SplashLogoView(visible: logoVisible)
                
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    logoVisible = true
                }
            }
        }
    }
}
