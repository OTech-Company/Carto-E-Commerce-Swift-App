//
//  BrandsProductsScreen.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct BrandsProductsScreen: View {
    let brandID: Int
    @ObservedObject private var viewModel: BrandsProductsViewModel

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .loading, .idle:
                LoadingView(width: .infinity)

            case .failure(let error):
                ErrorView(
                    width: .infinity,
                    message: error.localizedDescription
                )

            case .success(let products):
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(products) { product in
                        ProductCard(product: product)
                    }
                }.padding(16)
            }
        }.task {
            await viewModel.loadProducts(brandId: brandID)
        }
    }
}
//
//#Preview {
//    BrandsProductsScreen()
//}
