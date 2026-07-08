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
                
                Text("Your Cart is Wating")
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
                    .foregroundStyle(.orange)
                    .frame(width: 220, height: 48)
                    .background(
                        LinearGradient(
                            colors: colorScheme == .dark ? [
                                Color(.secondarySystemGroupedBackground),
                                Color.orange.opacity(0.3)
                            ] : [
                                .white,
                                Color.orange.opacity(0.18)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay {
                        Capsule()
                            .stroke(
                                Color.orange.opacity(0.25),
                                lineWidth: 1
                            )
                    }
                    .clipShape(Capsule())
                    .shadow(
                        color: .orange.opacity(0.18),
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
