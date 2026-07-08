//
//  ProductsInfoView.swift
//  Carto
//
//  Created by Manona on 27/06/2026.
//

import SwiftUI

struct ProductsInfoView: View {

    @StateObject private var viewModel: ProductsInfoViewModel
    @AppStorage("app_currency") var appCurrency: AppCurrency = .egyptianPound

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

                    if !viewModel.product.sizes.isEmpty {
                        SizeView(
                            sizes: viewModel.product.sizes,
                            selectedSize: $viewModel.selectedSize
                        )
                    } else {
                        Spacer()
                            .frame(width: 80)
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
                                .foregroundColor(viewModel.isFavorite ? .red : .primary)
                                .frame(width: 44, height: 44)
                                .background(Color(.systemBackground))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
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
                isOutOfStock: viewModel.isOutOfStock,
                maxQuantity: viewModel.product.variants.first?.inventoryQuantity ?? 0,
                quantity: $viewModel.quantity,
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.quantity) { newValue in
            viewModel.quantityChanged(to: newValue)
        }
        .ignoresSafeArea(edges: .top)
    }

}
