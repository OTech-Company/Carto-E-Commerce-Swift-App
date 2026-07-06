//
//  SwipeToAddView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct SwipeToAddView: View {
    let price: Double
    let compareAtPrice: Double?
    let discountPercentage: Int?
    let isOutOfStock: Bool
    let maxQuantity: Int

    @Binding var quantity: Int
    @State private var dragOffset: CGFloat = 0
    @State private var showAddedEffect = false
    @State private var addedEffectOffset: CGFloat = 0
    @State private var addedEffectOpacity: Double = 0

    private let threshold: CGFloat = 45

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(String(format: "$%.2f", price))
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)

                        if let compareAtPrice = compareAtPrice, compareAtPrice > price {
                            Text(String(format: "$%.2f", compareAtPrice))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .strikethrough()
                        }
                    }

                    if let discountPercentage = discountPercentage {
                        Text("-\(discountPercentage)% OFF")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .bold()
                    }
                    if isOutOfStock {
                        Text("Out of Stock")
                            .font(.caption.weight(.bold))
                            .foregroundColor(.red)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            Text("Swipe up to remove")
                .font(.subheadline)
                .bold()
                .foregroundColor(dragOffset < 0 ? .black : .secondary)
                .scaleEffect(dragOffset < 0 ? 1.05 : 1)
                .animation(.easeOut(duration: 0.2), value: dragOffset < 0)
                .padding(.bottom, -4)

            VStack(spacing: -6) {
                Image(systemName: "chevron.up")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.2))

                Image(systemName: "chevron.up")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.4))

                Image(systemName: "chevron.up")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.top, 4)
            .padding(.bottom, -25)

            Circle()
                .fill(Color.black)
                .frame(width: 50, height: 50)
                .overlay {
                    if quantity > 0 {
                        Text("\(quantity)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(systemName: "bag")
                            .foregroundColor(.white)
                            .font(.title3)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(), value: quantity)
                .padding(.top, 35)
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard !isOutOfStock else { return }

                            dragOffset = max(
                                -threshold - 10,
                                min(value.translation.height, threshold + 10)
                            )
                        }
                        .onEnded { value in
                            guard !isOutOfStock else {
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                                return
                            }
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            if value.translation.height >= threshold {
                                if quantity < maxQuantity {

                                    quantity += 1
                                    impact.impactOccurred()
                                    triggerAddedEffect()

                                }
                            } else if value.translation.height <= -threshold {

                                if quantity > 0 {
                                    quantity -= 1
                                    impact.impactOccurred()
                                }

                            }
                            withAnimation(.spring()) {
                                dragOffset = 0
                            }

                        }
                )
            Spacer(minLength: 0)

            VStack(spacing: -6) {
                Image(systemName: "chevron.down")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.6))

                Image(systemName: "chevron.down")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.4))

                Image(systemName: "chevron.down")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.2))
            }
            .padding(.bottom, 0)

            Text("Swipe down to add")
                .font(.subheadline)
                .bold()
                .foregroundColor(dragOffset > 0 ? .black : .secondary)
                .scaleEffect(dragOffset > 0 ? 1.05 : 1)
                .animation(.easeOut(duration: 0.2), value: dragOffset > 0)
                .padding(.top, 4)

            ZStack(alignment: .top) {
                Image(quantity > 0 ? "bagFull" : "bag")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding(.top, -15)
                    .frame(height: 165, alignment: .top)
                    .clipped()

                if showAddedEffect {
                    Text("+1")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .offset(y: addedEffectOffset)
                        .opacity(addedEffectOpacity)
                }
            }
        }
    }

    private func triggerAddedEffect() {
        showAddedEffect = true
        addedEffectOffset = 20
        addedEffectOpacity = 1

        withAnimation(.easeOut(duration: 0.6)) {
            addedEffectOffset = -30
            addedEffectOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showAddedEffect = false
        }
    }
}
