//
//  OrderSummarySection.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct OrderSummarySection: View {

    let subtotal: Double
    let discount: Double
    let freeDeliveryThreshold: Double
    let deliveryCost: Double

    private var hasFreeDelivery: Bool {
        subtotal >= freeDeliveryThreshold
    }

    private var finalDeliveryCost: Double {
        hasFreeDelivery ? 0 : deliveryCost
    }

    private var total: Double {
        subtotal + finalDeliveryCost - discount
    }

    var body: some View {

        VStack(spacing: 18) {

            summaryRow(
                title: "Subtotal",
                value: String(format: "$%.2f", subtotal)
            )

            HStack {
                Text("Delivery")
                    .foregroundStyle(.green)

                Spacer()

                if hasFreeDelivery {
                    Text("FREE")
                        .font(.caption.bold())
                        .foregroundStyle(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())

                } else {

                    Text(String(format: "$%.2f", deliveryCost))
                        .fontWeight(.semibold)
                }
            }

            summaryRow(
                title: "Discount",
                value: String(format: "-$%.2f", discount),
                valueColor: .red
            )

            DashDivider()

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Total Price")
                        .font(.headline)

                    Text("Including taxes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(String(format: "$%.2f", total))
                    .font(.title2.bold())
                    .foregroundStyle(Color("PrimaryColor"))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: .black.opacity(0.04),
            radius: 6,
            x: 0,
            y: 3
        )
        .shadow(
            color: Color.orange.opacity(0.18),
            radius: 20,
            x: 0,
            y: 8
        )
    }

    @ViewBuilder
    private func summaryRow(
        title: String,
        value: String,
        valueColor: Color = .primary
    ) -> some View {

        HStack {

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.semibold)
                .foregroundStyle(valueColor)
        }
    }
}

private struct DashDivider: View {

    var body: some View {

        GeometryReader { geo in

            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geo.size.width, y: 0))
            }
            .stroke(
                Color.gray.opacity(0.35),
                style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
            )
        }
        .frame(height: 1.5)
    }
}


