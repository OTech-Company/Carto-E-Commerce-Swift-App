//
//  PaymentSuccessView.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import SwiftUI

struct PaymentSuccessView: View {
    let order: AdminOrder
    let paymentMethod: PaymentMethod
    let onContinueShopping: () -> Void
    let onViewOrders: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                ZStack {
                    Circle().fill(Color(hex: "FF5A00").opacity(0.08)).frame(width: 140, height: 140)
                    Image(systemName: "checkmark.seal.fill")
                        .resizable().scaledToFit().frame(width: 70, height: 70)
                        .foregroundColor(Color(hex: "FF5A00"))
                }

                VStack(spacing: 12) {
                    Text("Payment Successful!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                    Text("Thank you for your purchase. Your order has been placed successfully.")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                VStack(spacing: 16) {
                    detailRow("Order Number", order.orderName)
                    Divider()
                    detailRow("Total Paid", CurrencyFormatter.format(order.total, currencyCode: order.currencyCode))
                    Divider()
                    detailRow("Payment Method", paymentMethod.displayName)
                    Divider()
                    detailRow("Date", formattedDate)
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onContinueShopping) {
                        Text("Continue Shopping")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color(hex: "FF5A00"))
                            .cornerRadius(12)
                    }
                    .buttonStyle(PremiumScaleButtonStyle())

                    Button(action: onViewOrders) {
                        Text("View Orders")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                    }
                    .buttonStyle(PremiumScaleButtonStyle())
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(size: 14, weight: .bold)).foregroundColor(.black)
        }
    }

    private var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: order.createdAt) else { return order.createdAt }
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}

import SwiftUI

struct PaymentFailureView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "FAFAFA").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle().fill(Color.red.opacity(0.1)).frame(width: 120, height: 120)
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                }

                VStack(spacing: 8) {
                    Text("Payment Failed")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Spacer()

                Button(action: onRetry) {
                    Text("Try Again")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.brandAccent)
                        .cornerRadius(12)
                }
                .buttonStyle(PremiumScaleButtonStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}
