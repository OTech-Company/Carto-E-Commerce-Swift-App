//
//  HomeProductGrid.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI

struct HomeProductGrid: View {
    let columns: [GridItem]
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("products_title")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            switch viewModel.productVM.state {
            case .loading, .idle:
                LoadingView(width: .infinity)
                    .padding(.top, 40)
            case .failure(let error):
                ErrorView(width: .infinity, message: error.localizedDescription)
                    .padding(.top, 40)
            case .success(let homeProducts):
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(homeProducts, id: \.id) { product in
                        Button {
                            router.push(to: .productDetails(product: product))
                        } label: {
                            ProductCard(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}