//
//  OrderDetailView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//


//
//  OrderDetailView.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import SwiftUI

struct OrderHistoryDetailView: View {
    let order: OrderEntity
    
    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.97)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Order Meta Summary Header card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Status")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(order.fulfillmentStatus == .fulfilled ? "Delivered" : "In Progress")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Date")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(order.formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total Amount")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("$\(order.totalPrice)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black.opacity(0.05), lineWidth: 1))
                    
                    Text("ITEMS IN THIS ORDER")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                        .padding(.top, 8)
                    
                    // List of structural item breakdown rows
                    LazyVStack(spacing: 12) {
                        ForEach(order.items) { item in
                            HStack(spacing: 16) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(white: 0.95))
                                    .frame(width: 56, height: 56)
                                    .overlay(
                                        Image(systemName: "tag")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.system(size: 16))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.title)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                    
                                    Text("Qty: \(item.quantity)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("$\(item.price)")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.black)
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
        .navigationTitle("Order \(order.orderNumber)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
