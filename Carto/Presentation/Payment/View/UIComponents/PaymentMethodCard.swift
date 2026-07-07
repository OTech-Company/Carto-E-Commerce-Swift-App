//
//  PaymentMethodCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct PaymentMethodCard: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.brandAccent.opacity(0.12) : Color(.systemGray6))
                        .frame(width: 38, height: 38)
                    Image(systemName: method.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .brandAccent : .secondary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.rawValue)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .brandAccent : Color(.systemGray4))
            }
            .padding(14)
            .background(isSelected ? Color.brandAccent.opacity(0.04) : Color.brandAccent.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Color.brandAccent : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(method.rawValue) payment method")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}
