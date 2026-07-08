//
//  HomeSearchView.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI

struct HomeSearchView: View {
    let searchText: String
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
            case .success:
                let filteredProducts = viewModel.productVM.allProducts.filter { product in
                    searchText.isEmpty || product.title.localizedCaseInsensitiveContains(searchText)
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredProducts, id: \.id) { product in
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
