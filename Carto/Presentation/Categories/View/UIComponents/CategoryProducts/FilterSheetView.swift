//
//  FilterSheetView.swift
//  Carto
//
//  Created by Osama Hosam on 01/07/2026.
//


import SwiftUI

struct FilterSheetView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            Text("Filters")
                .font(.title2.bold())

            Text("Price Range")

            Slider(value: .constant(100),
                   in: 0...500)

            Text("Brands")

            ScrollView(.horizontal) {

                HStack {

                    Text("Nike")
                    Text("Adidas")
                    Text("Puma")
                }
            }

            Text("Sizes")

            HStack {

                Text("S")
                Text("M")
                Text("L")
                Text("XL")
            }

            Button("Apply Filter") {

                dismiss()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}