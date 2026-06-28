//
//  SplashScreen.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SwiftUI
import SpriteKit

struct SplashView: View {
    @State private var isActive = false
    @State private var scene = SplashPhysicsScene()

    var body: some View {
        if isActive {
            ContentView()
        } else {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    Color(red: 0.96, green: 0.96, blue: 0.96)
                        .ignoresSafeArea()

                    // Physics Engine Layer
                    SpriteView(scene: scene, options: [.allowsTransparency])
                        .ignoresSafeArea()
                        .onAppear {
                            scene.safeAreaInsets = geometry.safeAreaInsets
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GeometryReader { geometry in
        SpriteView(
            scene: {
                let scene = SplashPhysicsScene()
                scene.safeAreaInsets = geometry.safeAreaInsets
                return scene
            }(),
            options: [.allowsTransparency]
        )
        .ignoresSafeArea()
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }
}
