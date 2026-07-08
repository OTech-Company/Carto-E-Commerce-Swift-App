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
            Text("description_label")
                .font(.headline)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {

                    Text(text)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(expanded ? nil : 2)
                        .frame(maxWidth: .infinity, alignment: .leading)

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
                .padding(.bottom, expanded ? 12 : 0)
            }
            .frame(height: boxHeight)
            .scrollDisabled(!expanded)
            .scrollIndicators(expanded ? .visible : .hidden)
            .overlay(alignment: .bottom) {
                if expanded {
                    ZStack(alignment: .bottom) {
                        LinearGradient(
                            colors: [
                                Color(.systemBackground).opacity(0),
                                Color(.systemBackground)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 8)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 1)
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }
}
