//
//  HomeView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct ProductEntity2: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let imageName: String
    let rate: Double
}

struct HomeView: View {

    //=============================Dummy data ===================================
    let ads: [ADEntity] = [
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
        ADEntity(
            title: "20% Discount",
            description: "on your first purchase",
            imageName: "Green 1"
        ),
    ]

    let products: [ProductEntity2] = [
        ProductEntity2(
            name: "Product 1",
            description: "Description 1",
            price: 10.0,
            imageName: "Green 1",
            rate: 3.4
        ),
        ProductEntity2(
            name: "Product 2",
            description: "Description 2",
            price: 10.0,
            imageName: "Green 1",
            rate: 3.4
        ),
        ProductEntity2(
            name: "Product 3",
            description: "Description 3",
            price: 10.0,
            imageName: "Green 1",
            rate: 3.4
        ),
        ProductEntity2(
            name: "Product 4",
            description: "Description 4",
            price: 10.0,
            imageName: "Green 1",
            rate: 3.4
        ),
    ]

    let brandsLogos = ["brand1", "brand2", "brand3", "brand4"]

    @State private var currentIndex: Int = 0
    @StateObject private var viewModel = DIContainer.shared.makeHomeViewModel()
    
    let timer = Timer.publish(
        every: 3,
        on: .main,
        in: .common
    ).autoconnect()

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                }
                TabView(selection: $currentIndex) {
                    ForEach(0..<ads.count) { index in
                        HomeBannerView(ad: ads[index])
                            .tag(index)
                    }
                }
                .frame(height: 200)
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .automatic)
                )
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % ads.count
                    }
                }

                Text("Brands")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("PrimaryColor"))

                HomeBrandView(viewModel: viewModel.brandVM, brandsLogos: brandsLogos)

                Spacer(minLength: 20)

                Text("Top Rated")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("PrimaryColor"))

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(products, id: \.id) { product in
                        HomeProductCardCell(
                            product: product,
                            onTab: {},
                            onAddToFav: {}
                        )
                    }
                }
            }.padding(.horizontal, 16)
        }.task {
            await viewModel.loadAllData()
        }
    }
}
