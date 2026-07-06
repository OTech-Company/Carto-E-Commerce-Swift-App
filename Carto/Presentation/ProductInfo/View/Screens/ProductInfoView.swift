//
//  ProductsInfoView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct ProductsInfoView: View {

    @StateObject private var viewModel: ProductsInfoViewModel

    init(viewModel: ProductsInfoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            HeaderView(title: viewModel.product.title.capitalizedFirstLetterOnly())
                .padding(.horizontal)
                .padding(.top, 60)

            VStack {
                HStack(alignment: .top) {

                    if viewModel.product.sizes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {

                            Text("Availability")
                                .bold()

                            Text("✓ In Stock")
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(width: 80, height: 40)
                                .background(Color.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black.opacity(0.25), lineWidth: 1)
                                }

                            Spacer()
                        }
                    } else {
                        SizeView(
                            sizes: viewModel.product.sizes,
                            selectedSize: $viewModel.selectedSize
                        )
                    }

                    Spacer()

                    ZStack {
                        Image("NIKE")
                            .resizable()
                            .scaledToFit()

                        AsyncImage(url: URL(string: viewModel.product.imageURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 190)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 190, height: 190)
                        }
                    }
                    .frame(width: 190, height: 190)

                    Spacer()

                    VStack {
                        Button {
                            viewModel.toggleFavorite()
                        } label: {
                            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.isFavorite ? .red : .black)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                }
                        }

                        Spacer().frame(height: 24)

                        if !viewModel.product.colors.isEmpty {
                            ColorView(
                                colorNames: viewModel.product.colors,
                                selectedColorIndex: $viewModel.selectedColorIndex
                            )
                        }

                        Spacer()
                    }
                    .frame(width: 60, height: 240, alignment: .top)
                }
                .padding(.horizontal)

                if !viewModel.product.description.isEmpty {
                    ExpandableText(text: viewModel.product.description)
                        .padding(.horizontal)
                        .padding(.top, 20)
                }
            }

            Spacer(minLength: 5)

            SwipeToAddView(
                price: viewModel.product.price,
                compareAtPrice: viewModel.product.compareAtPrice,
                discountPercentage: viewModel.product.discountPercentage,
                quantity: $viewModel.quantity
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.quantity) { newValue in
            if newValue > 0 {
                viewModel.addToCart()
            }
        }
        .ignoresSafeArea(edges: .top)
    }

}
