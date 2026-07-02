//
//  AddToCartCounter.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct AddToCartCounter: View {
    @State private var quantity: Int = 0

    var body: some View {
        ZStack {
            if quantity == 0 {
                addButton
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.85).combined(with: .opacity),
                        removal: .scale(scale: 0.85).combined(with: .opacity)
                    ))
            } else {
                counterView
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.85).combined(with: .opacity),
                        removal: .scale(scale: 0.85).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: quantity == 0)
    }

   
    private var addButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                quantity = 1
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "cart")
                    .font(.system(size: 11, weight: .bold))
                Text("Add to Cart")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 32)
            .background(Color(red: 0.145, green: 0.388, blue: 0.922))
            .clipShape(Capsule())
        }
        .buttonStyle(PressableButtonStyle())
    }

   
    private var counterView: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    if quantity > 1 {
                        quantity -= 1
                    } else {
                        quantity = 0
                    }
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.145, green: 0.388, blue: 0.922))
                    .frame(width: 30, height: 30)
            }

            Text("\(quantity)")
                .font(.system(size: 13, weight: .heavy))
                .foregroundColor(Color(red: 0.145, green: 0.388, blue: 0.922))
                .frame(maxWidth: .infinity)
                .contentTransition(.numericText())
                .id(quantity)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    quantity += 1
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(red: 0.145, green: 0.388, blue: 0.922))
                    .frame(width: 30, height: 30)
            }
        }
        .frame(height: 32)
        .background(
            Capsule()
                .fill(Color(red: 0.145, green: 0.388, blue: 0.922).opacity(0.10))
        )
        .overlay(
            Capsule()
                .stroke(Color(red: 0.145, green: 0.388, blue: 0.922).opacity(0.25), lineWidth: 1.5)
        )
        .background(.ultraThinMaterial, in: Capsule())
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
