//
//  CouponCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct CouponCard: View {
    @Binding var couponCode: String
    let isApplying: Bool
    let successMessage: String?
    let errorMessage: String?
    let onApply: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Promo Code")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                TextField("Enter coupon code", text: $couponCode)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.characters)
                
                Button(action: onApply) {
                    HStack {
                        if isApplying {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Apply")
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 80, height: 42)
                    .background(couponCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : Color.brandAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .disabled(couponCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isApplying)
            }
            
            if let success = successMessage {
                Label(success, systemImage: "checkmark.circle.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.green)
            }
            
            if let error = errorMessage {
                Label(error, systemImage: "exclamationmark.circle.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.red)
            }
        }
        .premiumCardStyle()
    }
}
