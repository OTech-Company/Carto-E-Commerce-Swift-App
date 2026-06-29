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
    @State private var isActive = false
    @State private var logoVisible = false
    @State private var scene = SplashPhysicsScene()

    var body: some View {
        
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Color(red: 0.96, green: 0.96, blue: 0.96)
                        .ignoresSafeArea()

                    // Physics Engine Layer (Shoes continuously falling)
                    SpriteView(scene: scene, options: [.allowsTransparency])
                        .ignoresSafeArea()
                        .onAppear {
                            scene.safeAreaInsets = geometry.safeAreaInsets
                        }
                    
                    // Static Logo Overlay without physics
                    SplashLogoView(visible: logoVisible)
                }
            }
            .onAppear {
                // Animate logo entrance
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    logoVisible = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
