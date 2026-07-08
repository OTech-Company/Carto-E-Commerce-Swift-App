//
//  FreeDeliveryBanner.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct FreeDeliveryBanner: View {

    let subtotal: Double
    let hasItems: Bool
    
    @AppStorage("app_currency") var appCurrency: AppCurrency = .egyptianPound

    private let freeDeliveryAmount: Double = 500

    private var reachedFreeDelivery: Bool {
        hasItems && subtotal >= freeDeliveryAmount
    }

    private var progress: Double {
        guard hasItems else { return 0 }
        return min(subtotal / freeDeliveryAmount, 1)
    }

    private var remaining: Double {
        max(freeDeliveryAmount - subtotal, 0)
    }

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            ZStack {
                Image(systemName: reachedFreeDelivery ? "checkmark" : "box.truck.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.orange)
            }

            VStack(alignment: .leading, spacing: 8) {

                Group {

                    if !hasItems {

                        Text("Add items to your cart to unlock free delivery")

                    } else if reachedFreeDelivery {

                        Text("You've unlocked FREE delivery!")

                    } else {

                        (
                            Text("You're ")
                            + Text(appCurrency.format(price: remaining))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            + Text(" away from ")
                            + Text("FREE")
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            + Text(" delivery!")
                        )
                    }
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

                GeometryReader { geo in

                    ZStack(alignment: .leading) {

                        Capsule()
                            .fill(Color.orange.opacity(0.15))
                            .frame(height: 8)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.orange.opacity(0.75),
                                        Color.orange
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * progress, height: 8)
                            .animation(.easeInOut(duration: 0.35), value: progress)
                    }
                }
                .frame(height: 8)

                HStack {

                    Text(
                        reachedFreeDelivery
                        ? "Your order qualifies for free shipping"
                        : "Add more items to unlock free delivery"
                    )
                    .foregroundStyle(.gray)

                    Spacer()

                    if hasItems && !reachedFreeDelivery {

                        Text("\(appCurrency.format(price: remaining)) left")
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                    }
                }
                .font(.system(size: 11))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        .animation(.easeInOut(duration: 0.35), value: subtotal)
    }
}
