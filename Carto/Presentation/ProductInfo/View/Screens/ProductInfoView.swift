//
//  ProductsInfoView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct ProductsInfoView: View {
    @State private var quantity = 0
    @State private var selectedSize = "UK 7"
    @State private var selectedColorIndex = 0

    var body: some View {
        VStack(spacing: 0) {

            HeaderView()
                .padding(.horizontal)

            HStack(alignment: .top) {
                SizeView(selectedSize: $selectedSize)

                ZStack {
                    Image("NIKE")
                        .resizable()
                        .scaledToFit()

                    Image("shoes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220)
                }

                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    Button {} label: {
                        Image(systemName: "heart")
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            }
                    }

                    ColorView(selectedColorIndex: $selectedColorIndex)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            Spacer(minLength: 0)

            SwipeToAddView(quantity: $quantity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}
