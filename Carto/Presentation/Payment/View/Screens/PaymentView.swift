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
    static let premiumBackground = Color(hex: "F4F5F7")
    static let premiumSubheadline = Color(UIColor.secondaryLabel)
    static let premiumBorder = Color(UIColor.systemGray5)
}

struct PremiumCardModifier: ViewModifier {
    var padding: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.premiumCardBg)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.03), radius: 15, x: 0, y: 8)
    }
}

extension View {
    func premiumCardStyle(padding: CGFloat = 20) -> some View {
        self.modifier(PremiumCardModifier(padding: padding))
    }
}

// MARK: - PaymentView

struct PaymentView: View {
    @StateObject private var viewModel: PaymentViewModel
    
    @State private var showAddressListSheet = false
    @State private var showAddAddressSheet = false
    @State private var showEditAddressSheet = false

    init(cart: CartModel) {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.makePaymentViewModel(cart: cart))
    }

    init(viewModel: PaymentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.premiumBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    DeliveryAddressSectionView(
                        viewModel: viewModel,
                        onChangeAddress: { showAddressListSheet = true },
                        onEditAddress: { showEditAddressSheet = true },
                        onAddAddress: { showAddAddressSheet = true }
                    )
                    OrderSummarySectionView(lines: viewModel.cart.lines)
                    PaymentMethodSectionView(selected: $viewModel.selectedPaymentMethod)
                    PriceBreakdownSectionView(viewModel: viewModel)
                    ShopifySecurityCardView()
                        .padding(.bottom, 110)
                }
                .padding(20)
            }

            StickyPaymentFooterView(
                totalAmount: viewModel.totalFormatted,
                isLoading: viewModel.isProcessing,
                canPlaceOrder: viewModel.canPlaceOrder
            ) {
                Task { await viewModel.placeOrder() }
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadAddresses()
        }
        .sheet(isPresented: $showAddressListSheet) {
            AddressListView(
                addresses: viewModel.addresses,
                onSelect: { viewModel.selectAddress($0) },
                onAddNew: { showAddAddressSheet = true }
            )
        }
        .sheet(isPresented: $showAddAddressSheet) {
            AddressFormBottomSheet(
                onAdd: { address in Task { await viewModel.addAddress(address) } },
                onEdit: { _ in }
            )
        }
        .sheet(isPresented: $showEditAddressSheet) {
            if let selected = viewModel.selectedAddress {
                AddressFormBottomSheet(
                    address: selected,
                    onAdd: { _ in },
                    onEdit: { address in Task { await viewModel.editAddress(id: selected.id, address: address) } }
                )
            }
        }
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

// MARK: - Section Headers

struct SectionTitleView: View {
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundColor(Color.gray)
            .padding(.horizontal, 4)
            .padding(.bottom, 2)
    }
}

// MARK: - Order Summary Section

struct OrderSummarySectionView: View {
    let lines: [CartLine]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Order Summary")

            VStack(spacing: 0) {
                ForEach(Array(lines.enumerated()), id: \.element.id) { index, line in
                    OrderLineRow(line: line)
                    if index < lines.count - 1 {
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
            .premiumCardStyle(padding: 16)
        }
    }
}

private struct OrderLineRow: View {
    let line: CartLine

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                Image(systemName: "bag.fill")
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.system(size: 20))
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 4) {
                Text(line.productTitle)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .lineLimit(1)
                Text("\(line.variantTitle)  •  Qty: \(line.quantity)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(line.price)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundColor(.black)
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

// MARK: - Payment Method Section

struct PaymentMethodSectionView: View {
    @Binding var selected: PaymentMethod

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Payment Method")

            VStack(spacing: 12) {
                ForEach(PaymentMethod.allCases) { method in
                    PaymentMethodRow(method: method, isSelected: selected == method) {
                        selected = method
                    }
                }
            }
        }
    }
}

private struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.brandAccent.opacity(0.12) : Color(.systemGray6))
                        .frame(width: 44, height: 44)
                    Image(systemName: method.iconName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isSelected ? .brandAccent : .gray)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(method.displayName)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text(method.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .brandAccent : Color(.systemGray4))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(isSelected ? 0.04 : 0.02), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.brandAccent : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PremiumScaleButtonStyle())
    }
}

// MARK: - Delivery Address Section

struct DeliveryAddressSectionView: View {
    @ObservedObject var viewModel: PaymentViewModel
    let onChangeAddress: () -> Void
    let onEditAddress: () -> Void
    let onAddAddress: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Delivery Address")
            
            if viewModel.isLoadingAddresses {
                AddressSkeletonView()
            } else if let address = viewModel.selectedAddress {
                DeliveryAddressCard(
                    address: address,
                    onEdit: onEditAddress,
                    onChange: onChangeAddress
                )
            } else {
                EmptyAddressCard(onAddAddress: onAddAddress)
            }
            
            if let error = viewModel.addressError {
                Text(error)
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Price Breakdown Section

struct PriceBreakdownSectionView: View {
    @ObservedObject var viewModel: PaymentViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitleView(title: "Payment Details")

            VStack(spacing: 16) {
                row("Subtotal", viewModel.subtotalFormatted)
                row("Shipping", viewModel.shippingLabel, valueColor: .successGreen)
                if let tax = viewModel.taxFormatted {
                    row("Estimated Tax", tax)
                }

                Divider().padding(.vertical, 4)

                HStack {
                    Text("Total")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(viewModel.totalFormatted)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundColor(.brandAccent)
                }
            }
            .premiumCardStyle()
        }
    }

    private func row(_ label: String, _ value: String, valueColor: Color = .black) -> some View {
        HStack {
            Text(label).font(.system(size: 15)).foregroundColor(.gray)
            Spacer()
            Text(value).font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(valueColor)
        }
    }
}

// MARK: - Shopify Security Card

struct ShopifySecurityCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.successGreen.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.successGreen)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Secure Checkout")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    Text("Encrypted & processed by Shopify")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image("shopify")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.02), radius: 10, x: 0, y: 4)

            HStack(spacing: 14) {
                Image("visa").resizable().scaledToFit().frame(height: 18)
                Image("master_card").resizable().scaledToFit().frame(height: 18)
                Image("apple_pay").resizable().scaledToFit().frame(height: 18)
                Image("paypal").resizable().scaledToFit().frame(height: 18)
            }
            .opacity(0.5)
        }
    }
}

// MARK: - Sticky Footer

struct StickyPaymentFooterView: View {
    let totalAmount: String
    let isLoading: Bool
    let canPlaceOrder: Bool
    let onAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.premiumBorder)
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                    Text(totalAmount)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                }

                Spacer()

                Button(action: onAction) {
                    HStack(spacing: 8) {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        Text("Place Order")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [Color.brandAccent, Color(hex: "FF7A00")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(18)
                    .shadow(color: Color.brandAccent.opacity(0.3), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(PremiumScaleButtonStyle())
                .disabled(!canPlaceOrder)
                .opacity(canPlaceOrder ? 1.0 : 0.6)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 20)
            .background(Color.white)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
