//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import SwiftUI

struct HomeBrandView: View {
    @ObservedObject var viewModel: HomeBrandsViewModel

    var body: some View {
        switch viewModel.state {
        case .loading, .idle:
            LoadingView(width: .infinity)
            
        case .failure(let error):
            ErrorView(
                width: .infinity,
                message: error.localizedDescription
            )
            
        case .success(let brands):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(brands.prefix(5)) { brand in
                        NavigationLink {
                            ProductsView(
                                brandID: brand.id,
                                viewModel: DIContainer.shared.makeCategoryProductViewModel()
                            )
                        } label: {
                            CircularNetworkImag(imagURL: brand.image ?? "")
                        }
                    }
                }.padding(.vertical, 12)
                    .padding(.horizontal, 4)
            }
        }
    }
}
