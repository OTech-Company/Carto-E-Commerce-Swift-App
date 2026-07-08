//
//  HomePromoBannerCarousel.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI
import Combine

struct HomePromoBannerCarousel: View {
    let ads: [ADEntity]
    @Binding var currentIndex: Int
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<ads.count, id: \.self) { index in
                HomeBannerView(ad: ads[index])
                    .tag(index)
            }
        }
        .frame(height: 200)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            HStack(spacing: 8) {
                ForEach(0..<ads.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .shadow(color: index == currentIndex ? Color.accentColor.opacity(0.6) : .clear, radius: 3)
                }
            }
            .padding(.bottom, 16)
        }
        .onReceive(timer) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % ads.count
            }
        }
    }
}