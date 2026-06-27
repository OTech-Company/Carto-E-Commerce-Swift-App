//
//  HomeView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeView: View {
    let ads: [ADEntity] = [
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
    ]

    @State private var currentIndex: Int = 0

    let timer = Timer.publish(
        every: 3,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<ads.count) { index in
                    HomeBannerView(ad: ads[index])
                        .tag(index)
                }
            }
            .frame(height: 250)
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .automatic)
            )
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % ads.count
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
