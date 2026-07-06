//
//  CouponSection.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CouponSection: View {

    @State private var coupon = ""
    @State private var isCouponApplied = false

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Label("Promo Code", systemImage: "ticket.fill")
                .font(.headline)

            HStack(spacing: 12) {

                HStack(spacing: 10) {

                    Image(systemName: "ticket.fill")
                        .foregroundStyle(.blue)

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

                    isCouponApplied.toggle()

                    if !isCouponApplied {
                        coupon = ""
                    }

                } label: {

                    Text(isCouponApplied ? "Undo" : "Apply")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(width: 80, height: 52)
                        .background(isCouponApplied ? .red : .blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
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
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
    }
}

