//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import SwiftUI

@available(iOS 17.0, *)
struct HomeBrandView: View {
    @ObservedObject var viewModel: HomeBrandsViewModel
    @Environment(Router<AppRoute>.self) private var router

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
                        Button {
                            router.push(to: .brandProducts(brandId: brand.id, brandName: brand.title))
                        } label: {
                            CircularNetworkImag(imagURL: brand.image ?? "")
                        }
                        .buttonStyle(.plain)
                    }
                }.padding(.vertical, 12)
                    .padding(.horizontal, 4)
            }
        }
    }
}
