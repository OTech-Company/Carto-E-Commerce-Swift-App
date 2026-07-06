//
//  CartItemCard.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartItemCard: View {

    let item: CartItem
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let canIncrement: Bool
    let canDecrement: Bool

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            imageView
                .frame(width: 100, height: 100)
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 10) {

                Text(item.product.title)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {

                    Circle()
                        .fill(colorForName(item.selectedColor))
                        .frame(width: 10, height: 10)
                        .overlay {
                            Circle()
                                .stroke(
                                    item.selectedColor.lowercased() == "white"
                                    ? Color.black.opacity(0.4)
                                    : Color.clear,
                                    lineWidth: 1
                                )
                        }

                    Text(item.selectedColor.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 4, height: 4)

                    Text("Size")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(item.selectedSize)
                        .font(.subheadline.weight(.semibold))
                }

                if item.isOutOfStock {
                    Text("Out of Stock")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red)
                }

                HStack(alignment: .center) {

                    Text("$\(item.product.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .layoutPriority(1)

                    Spacer(minLength: 8)

                    HStack(spacing: 4) {

                        Button {
                            guard canDecrement else { return }
                            onDecrement()
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(canDecrement ? .primary : .gray)
                                .frame(width: 24, height: 24)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.borderless)

                        Text("\(item.quantity)")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(minWidth: 28)

                        Button {
                            guard canIncrement && !item.isOutOfStock else { return }
                            onIncrement()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(
                                    (canIncrement && !item.isOutOfStock)
                                    ? .primary
                                    : .gray
                                )
                                .frame(width: 24, height: 24)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal, 6)
                    .frame(height: 28)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(0.02),
            radius: 4,
            x: 0,
            y: 2
        )
        .shadow(
            color: Color.orange.opacity(0.08),
            radius: 12,
            x: 0,
            y: 5
        )
        .listRowBackground(Color.clear)
    }

    @ViewBuilder
    private var imageView: some View {
        if let url = URL(string: item.product.imageURL),
           !item.product.imageURL.isEmpty {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        } else {
            Image("shoes")
                .resizable()
                .scaledToFit()
        }
    }

    private func colorForName(_ name: String) -> Color {
        switch name.lowercased() {
        case "black":
            return .black
        case "white":
            return .white
        case "red":
            return .red
        case "blue":
            return .blue
        case "green":
            return .green
        case "gray", "grey":
            return .gray
        case "yellow":
            return .yellow
        case "orange":
            return .orange
        case "brown":
            return .brown
        case "purple":
            return .purple
        case "pink":
            return .pink
        default:
            return .gray
        }
    }
}
