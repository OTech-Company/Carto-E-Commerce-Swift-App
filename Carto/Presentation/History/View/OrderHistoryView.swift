//
//  OrderHistoryView.swift
//  Carto
//
//  Created by Osama Abdellatif on 30/06/2026.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModel: OrderHistoryViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea() // Premium pitch-black canvas
                
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .goldAccent))
                            .scaleEffect(1.3)
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else if viewModel.orders.isEmpty {
                        emptyStateView
                    } else {
                        orderListView
                    }
                }
            }
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.fetchOrders()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var orderListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.orders) { order in
                    OrderCardRow(order: order)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "bag.badge.questionmark")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("No Orders Yet")
                .font(.headline)
                .foregroundColor(.white)
            Text("Your complete purchase history will display right here.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text(message)
                .foregroundColor(.red)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                Task { await viewModel.fetchOrders() }
            } label: {
                Text("Retry")
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.goldAccent)
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Supporting Row Component

struct OrderCardRow: View {
    let order: OrderEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(order.orderNumber)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(order.formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.white.opacity(0.12))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(order.itemCount) \(order.itemCount == 1 ? "item" : "items")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(order.totalPrice) \(order.currency)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.goldAccent)
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    StatusBadge(text: order.financialStatus.rawValue, isSuccess: order.financialStatus == .paid)
                    StatusBadge(text: order.fulfillmentStatus.rawValue, isSuccess: order.fulfillmentStatus == .fulfilled)
                }
            }
        }
        .padding()
        .background(Color(white: 0.10)) // Premium dark card elevation
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}

struct StatusBadge: View {
    let text: String
    let isSuccess: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isSuccess ? Color.green.opacity(0.12) : Color.orange.opacity(0.12))
            .foregroundColor(isSuccess ? .green : .orange)
            .cornerRadius(4)
    }
}

// MARK: - Styling Layout Extensions

extension Color {
    static let goldAccent = Color(red: 0.85, green: 0.67, blue: 0.28)
}
