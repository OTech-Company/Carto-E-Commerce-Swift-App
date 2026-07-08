//
//  HomeAISheetView.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI


struct HomeFloatingAIButton: View {
    @Binding var isShowingAISheet: Bool
    
    var body: some View {
        Button(action: {
            isShowingAISheet = true
        }) {
            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.title2)
                .foregroundColor(.white)
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [.blue, .cyan],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
        .transition(.scale.combined(with: .opacity))
    }
}

struct HomeAISheetView: View {
    @Binding var isShowingAISheet: Bool
    @EnvironmentObject private var router: Router<AppRoute>
    
    var body: some View {
        AIFeatureSheet {
            isShowingAISheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                router.push(to: .aiChat)
            }
        } onNavigateToComparison: {
            isShowingAISheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                router.push(to: .aiComparison)
            }
        } onNavigateToOutfit: {
            isShowingAISheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                router.push(to: .aiOutfit)
            }
        } onNavigateToImageSearch: {
            isShowingAISheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                router.push(to: .imageSearch)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
