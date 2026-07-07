//
//  DeliveryAddressCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct DeliveryAddressCard: View {
    let address: CustomerAddress
    let onChange: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.brandAccent.opacity(0.12))
                    .frame(width: 40, height: 40)
                Image(systemName: "mappin.and.tailingoutbound")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.brandAccent)
            }
            .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Customer Name")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if address.isDefault {
                        Text("Default")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.brandAccent)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.brandAccent.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                Text("\(address.address1), \(address.city), \(address.country)")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Button(action: onChange) {
                Text("Change")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.brandAccent)
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Change delivery address")
        }
        .premiumCardStyle()
    }
}
