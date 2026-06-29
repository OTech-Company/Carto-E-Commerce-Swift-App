//
//  ColorView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct ColorView: View {
    let colors: [Color] = [.red, Color(red: 0.2, green: 0.2, blue: 0.5)]
    @Binding var selectedColorIndex: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("Color")
                .bold()

            ForEach(colors.indices, id: \.self) { index in
                Button {
                    selectedColorIndex = index
                } label: {
                    Circle()
                        .fill(colors[index])
                        .frame(width: 28, height: 28)
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
        }
    }
}
