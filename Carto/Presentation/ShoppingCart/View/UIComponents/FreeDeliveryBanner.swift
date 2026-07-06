//
//  FreeDeliveryBanner.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct FreeDeliveryBanner: View {

    @State private var currentAmount: Double = 954.95
    private let freeDeliveryAmount: Double = 1000

    private var reachedFreeDelivery: Bool {
        currentAmount >= freeDeliveryAmount
    }

    private var progress: Double {
        min(currentAmount / freeDeliveryAmount, 1)
    }

    private var remaining: Double {
        max(freeDeliveryAmount - currentAmount, 0)
    }

    @State private var isPaused = false
    let demoTimer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 44, height: 44)

                Image(systemName: reachedFreeDelivery ? "checkmark" : "box.truck.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.blue)
            }

            VStack(alignment: .leading, spacing: 6) {

                Group {
                    if reachedFreeDelivery {
                        Text("You've unlocked FREE delivery!")
                            .foregroundStyle(.primary)
                    } else {
                        (
                            Text("You're ")
                            + Text("$\(remaining, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            + Text(" away from ")
                            + Text("FREE")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            + Text(" delivery!")
                        )
                        .foregroundStyle(.primary)
                    }
                }
                .font(.subheadline)
                .lineLimit(1)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 8)

                        Capsule()
                            .fill(.blue)
                            .frame(width: geo.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)

                HStack {
                    Text(reachedFreeDelivery
                         ? "Your order qualifies for free shipping"
                         : "Add more items to unlock free delivery")
                        .foregroundStyle(.secondary)

                    Spacer()

                    if !reachedFreeDelivery {
                        Text("$\(remaining, specifier: "%.2f") left")
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    }
                }
                .font(.caption)
                .lineLimit(1)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        .onReceive(demoTimer) { _ in
            guard !isPaused else { return }

            if currentAmount < freeDeliveryAmount {
                withAnimation(.easeInOut) {
                    currentAmount += 40
                }
            } else {
                isPaused = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        currentAmount = 954.95
                    }
                    isPaused = false
                }
            }
        }
    }
}

