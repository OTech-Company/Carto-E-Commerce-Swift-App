//
//  EmptyAddressCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct EmptyAddressCard: View {
    let onAddAddress: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash.circle")
                .font(.system(size: 36, weight: .light))
                .foregroundColor(.secondary)
                .accessibilityHidden(true)
            
            VStack(spacing: 4) {
                Text("No Delivery Address")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Add a delivery address before placing your order.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onAddAddress) {
                Text("Add Address")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.brandAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(PremiumScaleButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .premiumCardStyle()
    }
}
