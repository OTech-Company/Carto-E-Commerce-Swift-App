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
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: Color("primaryColor"))
                )
        case .failure(let error):
            Text("Error: \(error.localizedDescription)")
        case .success(let brands):
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(brands) { brand in
                        HomeBrandItem(barndLogo: brand.image ?? "")
                    }
                }.padding(.vertical, 12)
                    .padding(.horizontal, 4)
            }
        }
    }
}
