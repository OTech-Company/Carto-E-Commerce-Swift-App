//
//  OrderCardRow.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

struct OrderCardRow: View {
    let order: CustomerOrder // Uses the returned history model directly
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                
                // Item Descriptive Information Block (Clean, Text-Only Layout)
                VStack(alignment: .leading, spacing: 6) {
                    Text("order_number_format \(order.orderNumber)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    Text(order.processedAt)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    // Financial & Fulfillment Status Combo
                    HStack(spacing: 8) {
                        Text(order.fulfillmentStatus.uppercased() == "FULFILLED" ? "Delivered" : "In Progress")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(order.fulfillmentStatus.uppercased() == "FULFILLED" ? .green : .orange)
                        
                        Text("•")
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text(order.financialStatus.capitalized)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Text("\(order.currencyCode) \(order.totalPrice)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            
            // Primary Functional Blue Action Button
            Button {
                // Action logic to handle item re-ordering
            } label: {
                Text("reorder_btn")
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
