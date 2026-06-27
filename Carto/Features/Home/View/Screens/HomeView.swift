//
//  HomeView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

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

    let products: [ProductEntity] = [
        ProductEntity(
            name: "Product 1",
            description: "Description 1",
            price: 10.0,
            imageName: "Green 1"
        ),
        ProductEntity(
            name: "Product 2",
            description: "Description 2",
            price: 10.0,
            imageName: "Green 1"
        ),
        ProductEntity(
            name: "Product 3",
            description: "Description 3",
            price: 10.0,
            imageName: "Green 1"
        ),
        ProductEntity(
            name: "Product 4",
            description: "Description 4",
            price: 10.0,
            imageName: "Green 1"
        ),
    ]

    @State private var currentIndex: Int = 0

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
            VStack {
                TabView(selection: $currentIndex) {
                    ForEach(0..<ads.count) { index in
                        HomeBannerView(ad: ads[index])
                            .tag(index)
                    }
                }
                .frame(height: 250)
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .automatic)
                )
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % ads.count
                    }
                }

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(products, id: \.id) { product in
                        HomeProductCardCell(product: product) {

                        }
                    }
                }.padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    HomeView()
}
