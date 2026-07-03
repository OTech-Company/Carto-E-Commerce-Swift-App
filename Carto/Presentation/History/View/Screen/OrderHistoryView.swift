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
            .navigationDestination(for: OrderEntity.self) { order in
                OrderHistoryDetailView(order: order)
            }
            .task {
                await viewModel.fetchOrders()
            }
        }
    }
    
    private var filteredOrders: [OrderEntity] {
        switch selectedTab {
        case .active:
            return viewModel.orders.filter { $0.fulfillmentStatus != .fulfilled }
        case .completed:
            return viewModel.orders.filter { $0.fulfillmentStatus == .fulfilled }
        }
    }
    
    private var orderListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredOrders) { order in
                    NavigationLink(value: order) {
                        OrderCardRow(order: order)
                    }
                    .buttonStyle(PlainButtonStyle())
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
