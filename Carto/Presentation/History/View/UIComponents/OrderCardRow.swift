//
//  OrderCardRow.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

struct OrderCardRow: View {
    let order: CustomerOrder // Uses the returned history model directly
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                
                // Item Descriptive Information Block
                VStack(alignment: .leading, spacing: 6) {
                    Text("order_number_format \(order.orderNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary) // Theme-adaptive primary text
                        .lineLimit(1)
                    
                    Text(order.processedAt)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary) // Theme-adaptive secondary text
                    
                    // Financial & Fulfillment Status Combo
                    HStack(spacing: 8) {
                        Text(order.fulfillmentStatus.uppercased() == "FULFILLED" ? "Delivered" : "In Progress")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(order.fulfillmentStatus.uppercased() == "FULFILLED" ? .green : .orange)
                        
                        Text("•")
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        Text(order.financialStatus.capitalized)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("\(order.currencyCode) \(order.totalPrice)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            
            // Primary Functional Action Button matching App Accent/Tint Color
            Button {
                // Action logic to handle item re-ordering
            } label: {
                Text("reorder_btn")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(.systemBackground)) // Adapts to contrast properly
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.accentColor) // Tracks primary accent color asset configuration
                    .cornerRadius(10)
            }
        }
        .padding(.all, 16)
        .background(Color(.secondarySystemGroupedBackground)) // Secondary card background layer
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(Color.currentAppearanceOpacity), radius: 6, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 0.5) // Adaptive divider/border line
        )
    }
}

// MARK: - Dynamic Adaptive Shadow Helper
private extension Color {
    @MainActor static var currentAppearanceOpacity: Double {
        UITraitCollection.current.userInterfaceStyle == .dark ? 0.15 : 0.02
    }
}
