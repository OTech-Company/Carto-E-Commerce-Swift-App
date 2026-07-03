//
//  BrandsScreen.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct BrandsScreen: View {
    @ObservedObject var viewModel: HomeBrandsViewModel
    @State private var navigateToProducts = false
    
    @StateObject private var productsViewModel = DIContainer.shared.makeCategoryProductViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.brands) { brand in
                        BrandsCell(brand: brand){
                            navigateToProducts = true
                        }.navigationDestination(isPresented: $navigateToProducts) {
                            CategoryProductsView(
                                categoryId: "",
                                brandID: brand.id,
                                viewModel: productsViewModel
                                )
                        }
                    }
                }.padding(16)
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
