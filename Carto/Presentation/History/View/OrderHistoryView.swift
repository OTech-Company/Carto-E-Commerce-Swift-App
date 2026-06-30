//
//  OrderHistoryView.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

struct OrderHistoryView: View {
    @StateObject var viewModel: OrderHistoryViewModel
    @State private var selectedTab: HistoryTab = .completed
    
    enum HistoryTab: String, CaseIterable {
        case active = "Active"
        case completed = "Completed"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.96, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Styled Top Segment Tab Bar
                    HStack(spacing: 0) {
                        ForEach(HistoryTab.allCases, id: \.self) { tab in
                            Button {
                                selectedTab = tab
                            } label: {
                                VStack(spacing: 8) {
                                    Text(tab.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(selectedTab == tab ? .black : .gray)
                                    
                                    // Underline selection tracker indicator
                                    Rectangle()
                                        .fill(selectedTab == tab ? Color.black : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 8)
                    .background(Color(red: 0.96, green: 0.96, blue: 0.97))
                    
                    Divider()
                        .background(Color.black.opacity(0.08))
                    
                    // Main Content Canvas
                    Group {
                        if viewModel.isLoading && viewModel.orders.isEmpty {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding(.top, 40)
                            Spacer()
                        } else if let error = viewModel.errorMessage {
                            errorView(message: error)
                        } else if filteredOrders.isEmpty {
                            emptyStateView
                        } else {
                            orderListView
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            // Native structural routing map bind link destination
            .navigationDestination(for: OrderEntity.self) { order in
                OrderHistoryDetailView(order: order)
            }
            .task {
                await viewModel.fetchOrders()
            }
        }
    }
    
    // MARK: - Local Filter Logic
    private var filteredOrders: [OrderEntity] {
        switch selectedTab {
        case .active:
            return viewModel.orders.filter { $0.fulfillmentStatus != .fulfilled }
        case .completed:
            return viewModel.orders.filter { $0.fulfillmentStatus == .fulfilled }
        }
    }
    
    // MARK: - Subviews
    
    private var orderListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredOrders) { order in
                    // NavigationLink wraps the layout card securely
                    NavigationLink(value: order) {
                        OrderCardRow(order: order)
                    }
                    .buttonStyle(PlainButtonStyle()) // Eliminates automatic text blue highlight tinting
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "bag.badge.questionmark")
                .font(.system(size: 48))
                .foregroundColor(.gray.opacity(0.7))
            Text("No \(selectedTab.rawValue) Orders")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Text(message)
                .foregroundColor(.red)
                .font(.subheadline)
            Spacer()
        }
    }
}

// MARK: - Supporting Elevated Product Card Component (Fixed Scope Error)

struct OrderCardRow: View {
    let order: OrderEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Mock Image Placeholder box matching the item layout
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.95))
                    .frame(width: 84, height: 84)
                    .overlay(
                        Image(systemName: "tag")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 24))
                    )
                
                // Item Descriptive Information Block
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.items.first?.title ?? "Carto Premium Product")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text("Order #\(order.orderNumber)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text(order.fulfillmentStatus == .fulfilled ? "Delivered" : "In Progress")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.bottom, 2)
                    
                    Text("$\(order.totalPrice)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
            
            // Primary Functional Blue Action Button
            Button {
                // Action logic to handle item re-ordering
            } label: {
                Text("Reorder")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding(.all, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.02), radius: 6, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
