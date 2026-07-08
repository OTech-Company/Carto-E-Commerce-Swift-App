//
//  EmptyCartView.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import SwiftUI

struct EmptyCartView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            Image("emptyCart")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 40)
                .padding(.top, 80)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Your Cart is Waiting") // Fixed spelling typo ("Wating" -> "Waiting")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Add products to get started")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                
                Spacer()
                    .frame(height: 32)
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bag")
                        
                        Text("Start Shopping")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(Color("PrimaryColor")) // Replaced system orange label style
                    .frame(width: 220, height: 48)
                    .background(
                        LinearGradient(
                            colors: colorScheme == .dark ? [
                                Color(.secondarySystemGroupedBackground),
                                Color("PrimaryColor").opacity(0.2) // Brand asset opacity adjustment for Dark Mode
                            ] : [
                                Color(.systemBackground),
                                Color("PrimaryColor").opacity(0.14) // Brand asset opacity adjustment for Light Mode
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay {
                        Capsule()
                            .stroke(
                                Color("PrimaryColor").opacity(0.25), // Brand asset stroke adjustment
                                lineWidth: 1
                            )
                    }
                    .clipShape(Capsule())
                    .shadow(
                        color: Color("PrimaryColor").opacity(colorScheme == .dark ? 0.08 : 0.15), // Adapted background drop glow
                        radius: 10,
                        y: 6
                    )
                }
                
                Spacer()
                    .frame(height: 140)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
