//
//  SizeView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct SizeView: View {
    let sizes = ["UK 6", "UK 7", "UK 8", "UK 9"]
    @Binding var selectedSize: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Size")
                .bold()

            ForEach(sizes, id: \.self) { size in
                Button {
                    selectedSize = size
                } label: {
                    Text(size)
                        .font(.caption)
                        .frame(width: 60, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedSize == size ? Color.black : Color.gray.opacity(0.2),
                                    lineWidth: selectedSize == size ? 2 : 1
                                )
                        }
                        .cornerRadius(12)
                }
            }
        }
    }
}
