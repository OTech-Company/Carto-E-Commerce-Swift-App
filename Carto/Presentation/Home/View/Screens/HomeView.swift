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

    @State private var currentIndex: Int = 0
    @State private var navigateToBrands = false
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
        NavigationStack {
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

                    HStack {
                        Text("Brands")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color("PrimaryColor"))

                        Spacer()

                        Button {
                            navigateToBrands = true
                        } label: {
                            Text("see more")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color("PrimaryColor"))
                        }
                    }

                    HomeBrandView(
                        viewModel: viewModel.brandVM
                    )
                    .navigationDestination(isPresented: $navigateToBrands) {
                        BrandsScreen(viewModel: viewModel.brandVM)
                    }

                    Spacer(minLength: 20)

                    Text("Products")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryColor"))

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.productVM.products, id: \.id) { product in
                            NavigationLink {
                                ProductsInfoView(viewModel: DIContainer.shared.makeProductsInfoViewModel(product: product))
                            } label: {
                                ProductCard(product: product)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }.padding(.horizontal, 16)
            }.task {
                await viewModel.loadAllData()
            }
        }
    }
}
