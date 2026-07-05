//
//  BrandsScreen.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct BrandsScreen: View {
    @ObservedObject var viewModel: HomeBrandsViewModel
    @State private var searchText: String = ""
    @EnvironmentObject private var router: Router<AppRoute>
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var filteredBrands: [BrandEntity] {
        if searchText.isEmpty {
            return viewModel.brands
        } else {
            return viewModel.brands.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredBrands) { brand in
                    Button {
                        router.push(to: .brandProducts(brandId: brand.id, brandName: brand.title))
                    } label: {
                        BrandsCell(brand: brand)
                    }
                    .buttonStyle(.plain)
                }
            }.padding(16)
        }
        .navigationTitle("Brands")
        .searchable(text: $searchText, prompt: "Search brands")
        .task {
            if viewModel.brands.isEmpty {
                await viewModel.loadBrands()
            }
        }
    }
}

//#Preview {
//    BrandsScreen(brands: [
//        BrandEntity(
//            id: 1,
//            handle: "test",
//            title: "Test Brand",
//            updatedAt: "2023-01-01",
//            publishedAt: "2023-01-01",
//            sortOrder: "1",
//            image: nil
//        ),
//        BrandEntity(
//            id: 2,
//            handle: "test2",
//            title: "Test Brand 2",
//            updatedAt: "2023-01-02",
//            publishedAt: "2023-01-02",
//            sortOrder: "2",
//            image: nil
//        ),
//        BrandEntity(
//            id: 3,
//            handle: "test3",
//            title: "Test Brand 3",
//            updatedAt: "2023-01-03",
//            publishedAt: "2023-01-03",
//            sortOrder: "3",
//            image: nil
//        ),
//    ])
//}
