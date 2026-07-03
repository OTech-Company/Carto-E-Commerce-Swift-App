//
//  SwipeToAddView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct SwipeToAddView: View {
    @Binding var quantity: Int
    @State private var dragOffset: CGFloat = 0
    private let threshold: CGFloat = 60

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("$30.99")
                        .font(.title2)
                        .bold()
                    Text("10% OFF")
                        .foregroundColor(.red)
                        .font(.caption)
                        .bold()
                }

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        if quantity > 0 { quantity -= 1 }
                    } label: {
                        Text("−")
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }

                    Text("\(quantity)")
                        .font(.headline)
                        .frame(minWidth: 20)

                    Button {
                        quantity += 1
                    } label: {
                        Text("+")
                            .font(.title3)
                            .foregroundColor(.black)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)

            Text("Swipe down to add")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
                .padding(.bottom, 8)

            ZStack(alignment: .top) {
                VStack(spacing: 2) {
                    Image(systemName: "chevron.up")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black)
                    Image(systemName: "chevron.up")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.4))
                    Image(systemName: "chevron.up")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.15))
                }
                .offset(y: -52)

                VStack(spacing: 2) {
                    Image(systemName: "chevron.down")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.15))
                    Image(systemName: "chevron.down")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.4))
                    Image(systemName: "chevron.down")
                        .font(.title2).fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .offset(y: 52)

                Circle()
                    .fill(Color.black)
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "bag")
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = max(-threshold - 10, min(value.translation.height, threshold + 10))
                            }
                            .onEnded { value in
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                if value.translation.height >= threshold {
                                    quantity += 1
                                    impact.impactOccurred()
                                } else if value.translation.height <= -threshold {
                                    if quantity > 0 { quantity -= 1 }
                                    impact.impactOccurred()
                                }
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                }
                            }
                    )
                    .animation(.interactiveSpring(), value: dragOffset)
            }
            .frame(height: 150)

            Image("bag")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.top, -28)
        }
    }
}
