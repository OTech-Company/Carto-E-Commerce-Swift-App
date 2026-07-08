//
//  CouponSection.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CouponSection: View {

    @State private var coupon = ""
    @ObservedObject var viewModel: CartViewModel
    @ObservedObject private var cartStore = CartStateStore.shared

    var isCouponApplied: Bool {
        !(viewModel.cart?.discountCodes.filter { $0.isApplicable }.isEmpty ?? true)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Label("Promo Code", systemImage: "ticket.fill")
                    .font(.headline)
                
                Spacer()
                
                if let code = viewModel.cart?.discountCodes.first(where: { $0.isApplicable })?.code, !code.isEmpty {
                    Text("\(code) applied!")
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
                        .disabled(isCouponApplied)
                }
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Button {
                    withAnimation {
                        if isCouponApplied {
                            viewModel.removeDiscount()
                            coupon = ""
                            cartStore.clearCoupon()
                        } else {
                            viewModel.applyDiscount(code: coupon)
                        }
                    }
                } label: {

                    Text(isCouponApplied ? "Undo" : "Apply")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 84, height: 52)
                        .background(coupon.isEmpty ? Color.gray : Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(PressableButtonStyle())
                .disabled(coupon.isEmpty && !isCouponApplied)
            }

            if isCouponApplied {

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
        // Pre-fill from existing applied code on the cart
        .onAppear {
            if let applied = viewModel.cart?.discountCodes.first(where: { $0.isApplicable })?.code {
                coupon = applied
            } else if !cartStore.suggestedCouponCode.isEmpty {
                coupon = cartStore.suggestedCouponCode
            }
        }
        // React to banner tapping "Get Offer" — auto-fill the text field
        .onChange(of: cartStore.suggestedCouponCode) { newCode in
            guard !isCouponApplied, !newCode.isEmpty else { return }
            withAnimation { coupon = newCode }
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
