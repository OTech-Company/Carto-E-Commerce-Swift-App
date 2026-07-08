//
//  CouponSection.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CouponSection: View {

    @State private var coupon = ""
    @ObservedObject private var cartStore = CartStateStore.shared
    @Environment(\.colorScheme) var colorScheme

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Label("Promo Code", systemImage: "ticket.fill")
                    .font(.headline)
                
                Spacer()
                
                if let code = cartStore.appliedCouponCode, !cartStore.isCouponApplied, !code.isEmpty {
                    Text("\(code) ready!")
                        .font(.caption.weight(.bold))
                        .foregroundColor(Color(.systemBackground)) // High contrast text dynamic color
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("PrimaryColor")) // Corporate Orange asset
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 12) {

                HStack(spacing: 10) {

                    Image(systemName: "ticket.fill")
                        .foregroundStyle(Color("PrimaryColor")) // Corporate Orange asset

                    TextField("Enter coupon code", text: $coupon)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .disabled(cartStore.isCouponApplied)
                        .onChange(of: coupon) { newValue in
                            if !cartStore.isCouponApplied {
                                cartStore.appliedCouponCode = newValue
                            }
                        }
                }
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color(.systemGray6)) // Dynamic sub-fill element
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    withAnimation {
                        if cartStore.isCouponApplied {
                            cartStore.clearCoupon()
                            coupon = ""
                        } else {
                            cartStore.appliedCouponCode = coupon
                            cartStore.applyCoupon()
                        }
                    }
                } label: {

                    Text(cartStore.isCouponApplied ? "Undo" : "Apply")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(coupon.isEmpty ? Color(.placeholderText) : Color(.systemBackground))
                        .frame(width: 84, height: 52)
                        .background(coupon.isEmpty ? Color(.systemGray4) : Color("PrimaryColor")) // Corporate Orange asset
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(coupon.isEmpty)
            }

            if cartStore.isCouponApplied {

                HStack {

                    Spacer()

                    Label(
                        "Coupon applied successfully",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(.footnote)
                    .foregroundStyle(.green)

                    Spacer()
                }
                .padding(.top, 2)
            }
        }
        .onAppear {
            if let applied = cartStore.appliedCouponCode {
                coupon = applied
            }
        }
        .padding()
        // Updated to secondarySystemGroupedBackground to group properly inside Lists/ScrollViews across modes
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(colorScheme == .dark ? 0.2 : 0.02),
            radius: 4,
            x: 0,
            y: 2
        )
        .shadow(
            color: Color("PrimaryColor").opacity(colorScheme == .dark ? 0.04 : 0.08), // Softer branding glow in Dark Mode
            radius: 12,
            x: 0,
            y: 5
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}
