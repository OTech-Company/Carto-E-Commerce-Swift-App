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

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Label("Promo Code", systemImage: "ticket.fill")
                    .font(.headline)
                
                Spacer()
                
                if let code = cartStore.appliedCouponCode, !cartStore.isCouponApplied, !code.isEmpty {
                    Text("\(code) ready!")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .clipShape(Capsule())
                }
            }

            HStack(spacing: 12) {

                HStack(spacing: 10) {

                    Image(systemName: "ticket.fill")
                        .foregroundStyle(.orange)

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
                .background(Color(.systemGray6))
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
                        .foregroundStyle(.white)
                        .frame(width: 84, height: 52)
                        .background(coupon.isEmpty ? Color.gray : Color.orange)
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
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.02),
            radius: 4,
            x: 0,
            y: 2
        )
        .shadow(
            color: Color.orange.opacity(0.08),
            radius: 12,
            x: 0,
            y: 5
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}
