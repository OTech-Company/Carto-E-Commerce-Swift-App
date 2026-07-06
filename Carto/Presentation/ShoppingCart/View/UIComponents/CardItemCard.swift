//
//  CartItemCard.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartItemCard: View {

    @State private var quantity = 1

    var body: some View {

        HStack(alignment: .top, spacing: 14) {

            Image("shoes")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 10) {

                Text("Nike Club Max Running Shoes")
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {

                    Circle()
                        .fill(.blue)
                        .frame(width: 10, height: 10)

                    Text("Blue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 4, height: 4)

                    Text("Size")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("42")
                        .font(.subheadline.weight(.semibold))
                }

                HStack(spacing: 8) {

                    Text("$584.95")
                        .font(.title3.bold())

                    Spacer()

                    HStack(spacing: 10) {

                        Button {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(quantity == 1 ? .gray : .primary)
                        }
                        .disabled(quantity == 1)

                        Text("\(quantity)")
                            .font(.subheadline.weight(.semibold))
                            .frame(minWidth: 14)

                        Button {
                            quantity += 1
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 34)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                }
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
        .listRowBackground(Color.clear)
    }
}
