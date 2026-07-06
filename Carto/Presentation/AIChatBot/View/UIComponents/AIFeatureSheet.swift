//
//  AIFeatureItem.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//


import SwiftUI

struct AIFeatureItem: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
}

struct FeatureCard: View {
    let item: AIFeatureItem
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundColor(item.iconColor)
                    .frame(width: 32, height: 32)
                    .background(item.iconColor.opacity(0.1))
                    .clipShape(Circle())
                
                Text(item.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.ultraThinMaterial.opacity(0.75))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AIFeatureSheet: View {
    var onNavigateToChat: () -> Void
    
    let features: [AIFeatureItem] = [
        AIFeatureItem(icon: "bubble.left.and.bubble.right.fill", iconColor: .blue, title: "AI Shopping\nAssistant"),
        AIFeatureItem(icon: "scalemass.fill", iconColor: .orange, title: "AI Product\nComparison"),
        AIFeatureItem(icon: "sparkles", iconColor: .purple, title: "AI Outfit\nGenerator"),
        AIFeatureItem(icon: "chart.bar.xaxis", iconColor: .teal, title: "AI Shopping\nInsights")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 16)
            
            Text("How can Carto AI help you?")
                .font(.title2)
                .bold()
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                FeatureCard(item: features[0]) {
                    onNavigateToChat()
                }
                FeatureCard(item: features[1]) { print("Comparison tapped") }
                FeatureCard(item: features[2]) { print("Outfit tapped") }
                FeatureCard(item: features[3]) { print("Insights tapped") }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(AmbientBlobBackground())
    }
}
