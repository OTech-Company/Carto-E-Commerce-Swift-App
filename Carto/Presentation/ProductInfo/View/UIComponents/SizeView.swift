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
                                    selectedSize == size ? Color.black : Color.black.opacity(0.5),
                                    lineWidth: selectedSize == size ? 2 : 1.5
                                )
                        }
                        .cornerRadius(12)
                }
            }
        }
    }
}
