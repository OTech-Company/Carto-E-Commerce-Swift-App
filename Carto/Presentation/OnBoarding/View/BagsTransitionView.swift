//
//  BagsTransitionView.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SwiftUI

struct BagDrop: Identifiable {
    let id = UUID()
    let x: CGFloat
    let size: CGFloat
    let delay: Double
    let duration: Double
    let rotation: Double
}

struct BagsTransitionView: View {

    var onFinished: () -> Void

    private let screen = UIScreen.main.bounds

    private let bags: [BagDrop] = [
        BagDrop(x: 0.15, size: 180, delay: 0.0,  duration: 2.2, rotation: -8),
        BagDrop(x: 0.75, size: 120, delay: 0.3,  duration: 2.0, rotation:  6),
        BagDrop(x: 0.45, size: 260, delay: 0.5,  duration: 2.5, rotation: -3),
        BagDrop(x: 0.25, size: 100, delay: 0.7,  duration: 1.9, rotation:  10),
        BagDrop(x: 0.85, size: 140, delay: 0.2,  duration: 2.3, rotation: -5),
        BagDrop(x: 0.60, size: 110, delay: 0.8,  duration: 2.1, rotation:  7),
        BagDrop(x: 0.10, size: 130, delay: 0.9,  duration: 2.4, rotation: -12),
        BagDrop(x: 0.90, size: 95,  delay: 0.4,  duration: 1.8, rotation:  4),
        BagDrop(x: 0.38, size: 105, delay: 1.0,  duration: 2.0, rotation: -6),
        BagDrop(x: 0.68, size: 90,  delay: 0.6,  duration: 1.8, rotation:  9),
    ]

    @State private var dropped: [UUID: Bool] = [:]

    var body: some View {
        ZStack {
            // MARK: - Fully transparent — shows whatever is behind it
            Color.clear
                .ignoresSafeArea()

            ForEach(bags) { bag in
                Image("onboarding_bags")
                    .resizable()
                    .scaledToFit()
                    .frame(width: bag.size)
                    .rotationEffect(.degrees(bag.rotation))
                    .position(
                        x: screen.width * bag.x,
                        y: dropped[bag.id] == true
                            ? screen.height + bag.size
                            : -bag.size
                    )
                    .animation(
                        .easeInOut(duration: bag.duration)
                        .delay(bag.delay),
                        value: dropped[bag.id]
                    )
            }
        }
        .onAppear {
            for bag in bags { dropped[bag.id] = true }
            let maxTime = bags.map { $0.delay + $0.duration }.max() ?? 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + maxTime + 0.3) {
                onFinished()
            }
        }
    }
}


// MARK: - How To use it in login

//struct LoginScreen: View {
//
//    @State private var showBags = true
//
//    var body: some View {
//        ZStack {
//
//            // MARK: - Your actual login UI (bags fall over this)
//            loginContent
//
//            // MARK: - Bags overlay — transparent, shows login behind it
//            if showBags {
//                BagsTransitionView {
//                    withAnimation { showBags = false }
//                }
//            }
//        }
//    }
//
//    private var loginContent: some View {
//        VStack {
//            // your login fields here
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemBackground))
//    }
//}

