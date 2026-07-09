//
//  CartView.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartView: View {

    @StateObject private var viewModel: CartViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    @ObservedObject private var cartStore = CartStateStore.shared

    init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.hasItems {
                cartContent
            } else {
                EmptyCartView()
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(loadingOverlay)
    }

    private var cartContent: some View {
        List {
            FreeDeliveryBanner(
                subtotal: viewModel.subtotal,
                hasItems: viewModel.hasItems
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)

            ForEach(viewModel.lines, id: \.id) { line in
                CartItemCard(
                    line: line,
                    onIncrement: { viewModel.increment(line) },
                    onDecrement: { viewModel.decrement(line) },
                    onDelete: { viewModel.remove(line) }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        if let product = await viewModel.fetchProduct(for: line) {
                            router.push(to: .productDetails(product: product))
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button { viewModel.remove(line) } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }

            CouponSection(viewModel: viewModel)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)

            OrderSummarySection(
                subtotal: viewModel.subtotal,
                discount: cartStore.discountAmount,
                freeDeliveryThreshold: 500,
                deliveryCost: cartStore.deliveryFee
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)

            checkoutButton
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 20, trailing: 16))
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private var checkoutButton: some View {
        if viewModel.hasItems, let cart = viewModel.cart {
            Button {
                router.push(to: .payment(cart: cart))
            } label: {
                checkoutLabel(color: Color("PrimaryColor"))
            }
        } else {
            Button {} label: {
                checkoutLabel(color: .gray.opacity(0.5))
            }
            .disabled(true)
        }
    }

    private func checkoutLabel(color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "lock.fill")
            Text("proceed_to_checkout")
                .font(.subheadline.weight(.semibold))
            Spacer()
            Image(systemName: "arrow.right")
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if viewModel.isLoading {
            Color.black.opacity(0.08)
                .ignoresSafeArea()
                .overlay(ProgressView())
                .allowsHitTesting(false)
        }
    }
}
