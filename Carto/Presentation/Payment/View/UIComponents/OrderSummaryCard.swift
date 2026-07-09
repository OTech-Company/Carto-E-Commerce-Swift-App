//
//  OrderSummaryCard.swift
//  Carto
//
//  Created by Mohamed Ayman on 07/07/2026.
//

import SwiftUI

struct OrderSummary {
    let subtotal: Double
    let shipping: Double
    let discount: Double
    let total: Double
}

struct OrderSummaryCard: View {
    let summary: OrderSummary
    @AppStorage("app_currency") var appCurrency: AppCurrency = .egyptianPound
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.bottom, 4)
            
            SummaryRow(label: "Subtotal", value: appCurrency.format(price: summary.subtotal))
            SummaryRow(label: "Shipping", value: summary.shipping == 0 ? "Free" : appCurrency.format(price: summary.shipping), isHighlight: summary.shipping == 0)
            
            if summary.discount > 0 {
                SummaryRow(label: "Discount", value: "-" + appCurrency.format(price: summary.discount), isHighlight: true)
            }
            
            Divider()
                .padding(.vertical, 4)
            
            HStack {
                Text("Total")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Text(appCurrency.format(price: summary.total))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.brandAccent)
            }
        }
        .premiumCardStyle()
    }
}
