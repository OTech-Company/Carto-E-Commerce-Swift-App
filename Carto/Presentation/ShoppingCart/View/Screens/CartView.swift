//
//  CartView.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartView: View {

    @State private var items = [1, 2, 3]

    var body: some View {
        List {

            FreeDeliveryBanner()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)

            ForEach(items, id: \.self) { item in
                CartItemCard()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
                            if let index = items.firstIndex(of: item) {
                                items.remove(at: index)
                            }
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
                subtotal: 1169.90,
                discount: 120,
                freeDeliveryThreshold: 1000,
                deliveryCost: 50
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
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 20, trailing: 16))
            .listRowBackground(Color.clear)

        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CartView()
    }
}
