//
//  ExpandableText.swift
//  Carto
//
//  Created by Manona on 02/07/2026.
//

import SwiftUI

struct ExpandableText: View {
    let text: String

    @State private var expanded = false

    private let boxHeight: CGFloat = 90

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Description")
                .font(.headline)

            ScrollView {
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(expanded ? nil : 2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: boxHeight)
            .scrollDisabled(!expanded)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expanded.toggle()
                }
            } label: {
                Text(expanded ? "Show less" : "Show more")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
        }
    }
}
