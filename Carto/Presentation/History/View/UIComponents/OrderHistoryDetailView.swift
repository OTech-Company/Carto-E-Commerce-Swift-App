//
//  OrderHistoryDetailView.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

// MARK: - View Model Interface
@MainActor
final class OrderHistoryDetailViewModel: ObservableObject {
    @Published private(set) var orderDetail: CustomerOrderDetail? = nil
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let orderUseCase: OrderUseCaseProtocol
    private let orderId: String
    
    init(orderUseCase: OrderUseCaseProtocol, orderId: String) {
        self.orderUseCase = orderUseCase
        self.orderId = orderId
    }
    
    func loadDetails() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            self.orderDetail = try await orderUseCase.fetchDetails(id: orderId)
            print(orderDetail ?? "no details of order is back")
        } catch {
            print("❌ Detail ViewModel Error: \(error)")
            self.errorMessage = "Unable to load order profile details."
        }
        isLoading = false
    }
}

// MARK: - View Structure
struct OrderHistoryDetailView: View {
    @StateObject var viewModel: OrderHistoryDetailViewModel
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                } else if let error = viewModel.errorMessage {
                    errorStateView(message: error)
                } else if let detail = viewModel.orderDetail {
                    loadedDetailContent(detail: detail)
                } else {
                    errorStateView(message: "Order details could not be found.")
                }
            }
        }
        .navigationTitle(viewModel.orderDetail != nil ? "Order \(viewModel.orderDetail!.orderNumber)" : "Loading...")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDetails()
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private func loadedDetailContent(detail: CustomerOrderDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Order Meta Summary Header Card
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("status_label")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(detail.fulfillmentStatus.uppercased() == "FULFILLED" ? "Delivered" : "In Progress")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(detail.fulfillmentStatus.uppercased() == "FULFILLED" ? .green : .blue)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("date_label")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(detail.processedAt)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("total_amount_label")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(detail.currencyCode) \(detail.total)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.05), lineWidth: 1))
                
                Text("items_in_order_label")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                
                // List of structural item breakdown rows using OrderLineItemDetail
                LazyVStack(spacing: 12) {
                    ForEach(detail.lineItems, id: \.title) { item in
                        HStack(spacing: 16) {
                            if let imageUrlString = item.imageURL, let url = URL(string: imageUrlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 56, height: 56)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    case .failure, .empty:
                                        itemFallbackPlaceholder
                                    @unknown default:
                                        itemFallbackPlaceholder
                                    }
                                }
                            } else {
                                itemFallbackPlaceholder
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                
                                if let variant = item.variantTitle {
                                    Text(variant)
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                
                                Text("quantity_format \(item.quantity)")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if let priceString = item.price {
                                Text("\(detail.currencyCode) \(priceString)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.04), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    private var itemFallbackPlaceholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(white: 0.95))
            .frame(width: 56, height: 56)
            .overlay(
                Image(systemName: "tag")
                    .foregroundColor(.gray.opacity(0.5))
                    .font(.system(size: 16))
            )
    }
    
    private func errorStateView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}
