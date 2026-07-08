//
//  ColorView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct ColorView: View {
    let colorNames: [String]
    @Binding var selectedColorIndex: Int

    var body: some View {
        if colorNames.isEmpty {
            Spacer()
        } else {
            VStack(spacing: 16) {
                Text("color_label")
                    .bold()

                ForEach(colorNames.indices, id: \.self) { index in
                    Button {
                        selectedColorIndex = index
                    } label: {
                        Circle()
                            .fill(colorFromName(colorNames[index]))
                            .frame(width: 28, height: 28)
                            .overlay {
                                Circle()
                                    .stroke(
                                        borderColor(for: colorNames[index]),
                                        lineWidth: borderWidth(for: colorNames[index])
                                    )
                            }
                            .overlay {
                                Circle()
                                    .stroke(
                                        selectedColorIndex == index ? Color.black : Color.clear,
                                        lineWidth: 2.5
                                    )
                                    .padding(-4)
                            }
                    }
                }

                Spacer()
            }
        }
    }

    private func borderColor(for name: String) -> Color {
        name.lowercased() == "white"
        ? Color.black.opacity(0.5)
        : Color.gray.opacity(0.35)
    }

    private func borderWidth(for name: String) -> CGFloat {
        name.lowercased() == "white" ? 1.5 : 1
    }

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "black":
            return .black
        case "white":
            return .white
        case "red":
            return .red
        case "blue":
            return Color(red: 0.2, green: 0.2, blue: 0.5)
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "pink":
            return .pink
        case "orange":
            return .orange
        case "purple":
            return .purple
        case "gray", "grey":
            return .gray
        case "brown":
            return .brown
        default:
            return .gray
        }
    }
}
