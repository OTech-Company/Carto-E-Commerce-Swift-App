//
//  ProductColorsView.swift
//  Carto
//
//  Created by Manona on 29/06/2026.
//

import SwiftUI

struct ProductColorsView: View {
    let colorNames: [String]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(colorNames.indices, id: \.self) { index in
                let color = colorFromName(colorNames[index])
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .overlay(
                        Circle()
                            .stroke(
                                colorNames[index].lowercased() == "white"
                                    ? Color.black.opacity(0.5)
                                    : Color.clear,
                                lineWidth: 1
                            )
                    )
            }
        }
    }

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "gray", "grey": return .gray
        case "yellow": return .yellow
        case "orange": return .orange
        case "brown": return .brown
        case "purple": return .purple
        case "pink": return .pink
        case "beige": return Color(red: 0.96, green: 0.96, blue: 0.86)
        case "navy": return Color(red: 0.0, green: 0.0, blue: 0.5)
        case "maroon": return Color(red: 0.5, green: 0.0, blue: 0.0)
        case "teal": return .teal
        case "cyan": return .cyan
        case "indigo": return .indigo
        case "mint": return .mint
        default: return .gray
        }
    }
}
