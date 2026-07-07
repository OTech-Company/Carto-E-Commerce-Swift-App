//
//  PaymentView.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//

import SwiftUI

// MARK: - Design Tokens

extension Color {
    static let brandAccent = Color(hex: "FF5A00")
    static let successGreen = Color(hex: "00BC7D")
    static let premiumCardBg = Color.white
    static let premiumBackground = Color(hex: "FAFAFA")
    static let premiumSubheadline = Color(UIColor.secondaryLabel)
    static let premiumBorder = Color(UIColor.systemGray5)
}

struct PremiumCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(Color.premiumCardBg)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.02), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func premiumCardStyle() -> some View { self.modifier(PremiumCardModifier()) }
}

// MARK: - PaymentView

struct PaymentView: View {
    @StateObject private var viewModel: PaymentViewModel

    init(cart: CartModel) {
        _viewModel = StateObject(wrappedValue: PaymentViewModel(cart: cart,paymobCoordinator: nil))
    }

    init(viewModel: PaymentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.premiumBackground.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        OrderSummarySectionView(lines: viewModel.cart.lines)
                        PaymentMethodSectionView(selected: $viewModel.selectedPaymentMethod)
                        PriceBreakdownSectionView(viewModel: viewModel)
                        ShopifySecurityCardView()
                            .padding(.bottom, 110)
                    }
                    .padding(16)
                }

                StickyPaymentFooterView(
                    totalAmount: viewModel.totalFormatted,
                    isLoading: viewModel.isProcessing
                ) {
                    Task { await viewModel.placeOrder() }
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: isShowingSuccess) {
                if let order = viewModel.completedOrder, let method = viewModel.lastPaymentMethodUsed {
                    PaymentSuccessView(order: order, paymentMethod: method) {}
                }
            }
            .fullScreenCover(isPresented: isShowingFailure) {
                if case .failed(let message) = viewModel.phase {
                    PaymentFailureView(message: message) { viewModel.retry() }
                }
            }
        }
    }

    // MARK: - Phase Bindings

    private var isShowingSuccess: Binding<Bool> {
        Binding(
            get: { if case .success = viewModel.phase { return true }; return false },
            set: { if !$0 { viewModel.retry() } }
        )
    }

    private var isShowingFailure: Binding<Bool> {
        Binding(
            get: { if case .failed = viewModel.phase { return true }; return false },
            set: { if !$0 { viewModel.retry() } }
        )
    }
}

// MARK: - Order Summary Section

struct OrderSummarySectionView: View {
    let lines: [CartLine]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)

            ForEach(lines, id: \.id) { line in
                OrderLineRow(line: line)
            }
        }
        .premiumCardStyle()
    }
}

private struct OrderLineRow: View {
    let line: CartLine

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                Image(systemName: "bag.fill")
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 56, height: 56)

            VStack(alignment: .leading, spacing: 3) {
                Text(line.productTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                Text("\(line.variantTitle)  •  Qty: \(line.quantity)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(line.price)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.premiumBorder, lineWidth: 1)
        )
    }
}

// MARK: - Payment Method Section (modern selection UI)

struct PaymentMethodSectionView: View {
    @Binding var selected: PaymentMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Payment Method")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)

            ForEach(PaymentMethod.allCases) { method in
                PaymentMethodRow(method: method, isSelected: selected == method) {
                    selected = method
                }
            }
        }
        .premiumCardStyle()
    }
}

private struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.brandAccent.opacity(0.12) : Color(.systemGray6))
                        .frame(width: 42, height: 42)
                    Image(systemName: method.iconName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isSelected ? .brandAccent : .gray)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(method.displayName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    Text(method.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .brandAccent : Color(.systemGray4))
            }
            .padding(14)
            .background(isSelected ? Color.brandAccent.opacity(0.05) : Color.white)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.brandAccent : Color.premiumBorder, lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .buttonStyle(PremiumScaleButtonStyle())
    }
}

// MARK: - Shopify Security Card

struct ShopifySecurityCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image("shopify").resizable().scaledToFit().frame(height: 22)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "lock.shield.fill").font(.system(size: 12)).foregroundColor(.successGreen)
                    Text("Encrypted").font(.system(size: 12, weight: .bold)).foregroundColor(.successGreen)
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(Color.successGreen.opacity(0.08))
                .cornerRadius(8)
            }

            Text("Your payment information is completely encrypted and securely processed.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .lineSpacing(3)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 10) {
                Image("visa").resizable().scaledToFit().frame(height: 24)
                Image("master_card").resizable().scaledToFit().frame(height: 24)
                Image("apple_pay").resizable().scaledToFit().frame(height: 24)
                Image("paypal").resizable().scaledToFit().frame(height: 24)
                Image("shoppay").resizable().scaledToFit().frame(height: 24)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
        .premiumCardStyle()
    }
}

// MARK: - Price Breakdown Section

struct PriceBreakdownSectionView: View {
    @ObservedObject var viewModel: PaymentViewModel

    var body: some View {
        VStack(spacing: 14) {
            row("Subtotal", viewModel.subtotalFormatted)
            row("Shipping", viewModel.shippingLabel, valueColor: .successGreen)
            if let tax = viewModel.taxFormatted {
                row("Estimated Tax", tax)
            }

            Divider().padding(.vertical, 4)

            HStack {
                Text("Total").font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                Spacer()
                Text(viewModel.totalFormatted)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.brandAccent)
            }
        }
        .premiumCardStyle()
    }

    private func row(_ label: String, _ value: String, valueColor: Color = .black) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(size: 14, weight: .medium)).foregroundColor(valueColor)
        }
    }
}

// MARK: - Sticky Footer

struct StickyPaymentFooterView: View {
    let totalAmount: String
    let isLoading: Bool
    let onAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Amount").font(.system(size: 13, weight: .medium)).foregroundColor(.gray)
                    Text(totalAmount).font(.system(size: 22, weight: .bold)).foregroundColor(.black)
                }

                Spacer()

                Button(action: onAction) {
                    HStack(spacing: 10) {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "creditcard.fill").font(.system(size: 16, weight: .semibold))
                        }
                        Text("Place Order").font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.brandAccent)
                    .cornerRadius(16)
                    .shadow(color: Color.brandAccent.opacity(0.2), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(PremiumScaleButtonStyle())
                .disabled(isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 16)
            .background(Color.white)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
