//
//  PlaceOrderButton.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct PlaceOrderButton: View {
    let totalAmount: String
    let isEnabled: Bool
    let isLoading: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Place Order")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text("•")
                    Text(totalAmount)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isEnabled ? Color.brandAccent : Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: isEnabled ? Color.brandAccent.opacity(0.25) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PremiumScaleButtonStyle())
        .disabled(!isEnabled || isLoading)
    }
}
