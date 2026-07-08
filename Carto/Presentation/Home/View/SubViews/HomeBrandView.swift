//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import SwiftUI

struct HomeBrandView: View {
    @ObservedObject var viewModel: HomeBrandsViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    
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
                                .shadow(color: Color("PrimaryColor").opacity(0.15), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }
                }.padding(.vertical, 12)
                    .padding(.horizontal, 4)
            }
        }
    }
}
