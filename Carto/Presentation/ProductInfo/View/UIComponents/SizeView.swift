//
//  SizeView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct SizeView: View {
    let sizes: [String]
    @Binding var selectedSize: String

    private let buttonHeight: CGFloat = 40
    private let spacing: CGFloat = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("size_label")
                .bold()

            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    ForEach(sizes, id: \.self) { size in
                        Button {
                            selectedSize = size
                        } label: {
                            Text(size)
                                .font(.caption)
                                .frame(width: 60, height: buttonHeight)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedSize == size ? Color.black : Color.black.opacity(0.5),
                                            lineWidth: selectedSize == size ? 2 : 1.5
                                        )
                                }
                                .cornerRadius(12)
                        }
                    }

                    if sizes.count > 4 {
                        Spacer()
                            .frame(height: 8)
                    }
                }
            }
            .frame(height: sizes.count > 4 ? (buttonHeight * 4 + spacing * 3) : nil)
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) {
                if sizes.count > 4 {
                    ZStack(alignment: .bottom) {
                        LinearGradient(
                            colors: [
                                Color(.systemBackground).opacity(0),
                                Color(.systemBackground)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 18)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, -8)
                    }
                    .allowsHitTesting(false)
                }
            }
        }
    }
}
