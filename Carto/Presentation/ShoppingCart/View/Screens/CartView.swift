//
//  CartView.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartView: View {
    
    @StateObject private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.cartItems.isEmpty {
                EmptyCartView()
            } else {
                List {
                    
                    FreeDeliveryBanner(
                        subtotal: viewModel.subtotal,
                        hasItems: viewModel.hasItems
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    
                    ForEach(viewModel.cartItems) { item in
                        CartItemCard(
                            item: item,
                            onIncrement: { viewModel.increment(item) },
                            onDecrement: { viewModel.decrement(item) },
                            onDelete: { viewModel.remove(item) },
                            canIncrement: viewModel.canIncrement(item),
                            canDecrement: viewModel.canDecrement(item)
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.didTapItem(item)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .listRowBackground(Color.clear)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                viewModel.remove(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    CouponSection()
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                    
                    OrderSummarySection(
                        subtotal: viewModel.subtotal,
                        discount: viewModel.discount,
                        freeDeliveryThreshold: 500,
                        deliveryCost: viewModel.deliveryFee
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                            
                            Text("Proceed to Checkout")
                                .font(.subheadline.weight(.semibold))
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 20, trailing: 16))
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(
            isPresented: Binding(
                get: { viewModel.navigateToProduct != nil },
                set: { if !$0 { viewModel.navigateToProduct = nil } }
            )
        ) {
            if let product = viewModel.navigateToProduct {
                ProductsInfoView(
                    viewModel: DIContainer.shared.makeProductsInfoViewModel(product: product)
                )
            }
        }
    }
}
