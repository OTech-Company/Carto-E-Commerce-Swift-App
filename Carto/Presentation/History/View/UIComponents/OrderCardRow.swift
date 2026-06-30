//
//  OrderCardRow.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

struct OrderCardRow: View {
    let order: OrderEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                // Product Image Container View (with Dynamic Asynchronous Network Loader)
                if let imageUrlString = order.items.first?.imageUrl, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 84, height: 84)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .failure, .empty:
                            fallbackPlaceholderView(width: 84, height: 84)
                        @unknown default:
                            fallbackPlaceholderView(width: 84, height: 84)
                        }
                    }
                } else {
                    fallbackPlaceholderView(width: 84, height: 84)
                }
                
                // Item Descriptive Information Block
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(order.formattedDate)
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
    
    @ViewBuilder
    private func fallbackPlaceholderView(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(white: 0.95))
            .frame(width: width, height: height)
            .overlay(
                Image(systemName: "tag")
                    .foregroundColor(.gray.opacity(0.6))
                    .font(.system(size: 24))
            )
    }
}
