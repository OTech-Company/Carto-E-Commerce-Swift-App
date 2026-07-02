//
//  HomeBrandView.swift
//  Carto
//
//  Created by Nadin Ahmed on 01/07/2026.
//

import SwiftUI

struct HomeBrandView: View {
    @ObservedObject var viewModel: HomeBrandsViewModel
    let onViewMoreClicked: () -> Void

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
                        HomeBrandItem(barndLogo: brand.image ?? "")
                    }

                    if brands.count > 5 {
                        Button {
                            onViewMoreClicked()
                        } label: {
                            VStack {
                                Image(systemName: "ellipsis.circle")
                                    .font(.system(size: 28))

                                Text("See More")
                                    .font(.caption)
                                    .padding(.top, 4)
                            }
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                        }
                    }
                }.padding(.vertical, 12)
                    .padding(.horizontal, 4)
            }
        }
    }
}
