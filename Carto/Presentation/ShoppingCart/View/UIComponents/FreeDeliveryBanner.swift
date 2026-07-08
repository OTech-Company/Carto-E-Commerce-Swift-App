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
    @Environment(\.colorScheme) var colorScheme

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
                    .foregroundStyle(Color("PrimaryColor")) // Corporate branding orange asset
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
                                .foregroundColor(Color("PrimaryColor")) // Corporate branding orange asset
                            + Text(" away from ")
                            + Text("FREE")
                                .fontWeight(.bold)
                                .foregroundColor(Color("PrimaryColor")) // Corporate branding orange asset
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
                            .fill(Color("PrimaryColor").opacity(colorScheme == .dark ? 0.12 : 0.15)) // Adapted bar track background tint
                            .frame(height: 8)

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color("PrimaryColor").opacity(0.75),
                                        Color("PrimaryColor")
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
                    .foregroundStyle(.secondary) // Converted from hard gray to responsive secondary label layer

                    Spacer()

                    if hasItems && !reachedFreeDelivery {

                        Text("\(appCurrency.format(price: remaining)) left")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("PrimaryColor")) // Corporate branding orange asset
                    }
                }
                .font(.system(size: 11))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            }
        }
        .padding()
        // Switched to semantic grouped background for optimal card style cell nesting inside Lists
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(colorScheme == .dark ? 0.2 : 0.04),
            radius: 6,
            y: 3
        )
        .animation(.easeInOut(duration: 0.35), value: subtotal)
    }
}
