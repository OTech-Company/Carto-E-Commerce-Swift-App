//
//  CartItemCard.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//
//
//  CartItemCard.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import SwiftUI

struct CartItemCard: View {

    let line: CartLine
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void

    @AppStorage("app_currency") var appCurrency: AppCurrency = .egyptianPound
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Group {
                if let urlString = line.imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit()
                        case .failure:
                            Image(systemName: "photo").foregroundStyle(.secondary)
                        default:
                            ProgressView()
                        }
                    }
                } else {
                    Image(systemName: "photo").foregroundStyle(.secondary)
                }
            }
            .frame(width: 100, height: 100)
            .background(Color(.systemGray6))
            .padding(8)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 10) {

                Text(line.productTitle)
                    .font(.headline)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 34)

                Text(line.variantTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(alignment: .center) {

                    Text(appCurrency.format(price: Double(line.price) ?? 0))
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .layoutPriority(1)

                    Spacer(minLength: 8)

                    HStack(spacing: 4) {

                        Button {
                            onDecrement()
                        } label: {
                            Image(systemName: "minus")
                                .font(.system(size: 11, weight: .bold))
                                .frame(width: 24, height: 24)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.borderless)

                        Text("\(line.quantity)")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(minWidth: 28)

                        Button {
                            onIncrement()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 11, weight: .bold))
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
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(colorScheme == .dark ? 0.2 : 0.02),
            radius: 4,
            x: 0,
            y: 2
        )
        // Softened brand drop shadow to fit Light and Dark view scopes natively
        .shadow(
            color: Color("PrimaryColor").opacity(colorScheme == .dark ? 0.08 : 0.15),
            radius: 12,
            x: 0,
            y: 5
        )
        .overlay(alignment: .topTrailing) {
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(.red)
                    .frame(width: 38, height: 38)
                    .background(Color.red.opacity(colorScheme == .dark ? 0.20 : 0.12))
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
            .offset(x: -8, y: 8)
        }
        .listRowBackground(Color.clear)
    }
}
