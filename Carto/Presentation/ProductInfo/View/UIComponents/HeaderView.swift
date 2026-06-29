//
//  HeaderView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Button {} label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }

            Spacer()
            Text("Air Max 200 SE").bold()
            Spacer()

            Button {} label: {
                Image(systemName: "cart")
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
            }
        }
    }
}
