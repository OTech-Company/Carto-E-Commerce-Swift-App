//
//  DeliveryAddressCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct DeliveryAddressCard: View {
    let address: CustomerAddress
    let onEdit: () -> Void
    let onChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.brandAccent.opacity(0.12))
                        .frame(width: 46, height: 46)
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.brandAccent)
                }
                .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text("\(address.firstName) \(address.lastName)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        if address.isDefault {
                            Text("DEFAULT")
                                .font(.system(size: 10, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.brandAccent)
                                .cornerRadius(6)
                        }
                    }
                    
                    Text("\(address.address1), \(address.city), \(address.country)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineSpacing(2)
                        .lineLimit(2)

                    if !address.phone.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "phone.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(.systemGray3))
                            Text(address.phone)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .padding(.top, 2)
                    }
                }
                
                Spacer(minLength: 0)
            }
            
            Divider()
                .padding(.horizontal, -20)
                .padding(.bottom, 4)
            
            HStack(spacing: 0) {
                Button(action: onEdit) {
                    HStack(spacing: 6) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.darkGray))
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Divider()
                    .frame(height: 20)
                
                Button(action: onChange) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("Change Address")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.brandAccent)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, -4)
        }
        .premiumCardStyle()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.brandAccent.opacity(0.3), lineWidth: 1)
        )
    }
}
