//
//  HomeView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeView: View {

    let ads: [ADEntity] = [
        ADEntity(
            title: "10% Discount",
            description: "Get 10% off your purchase",
            imageName: "coupon_10",
            couponCode: "Carto10",
            discountPercentage: 10
        ),
        ADEntity(
            title: "20% Discount",
            description: "Get 20% off your purchase",
            imageName: "coupon_20",
            couponCode: "Carto20",
            discountPercentage: 20
        ),
        ADEntity(
            title: "50% Discount",
            description: "Get 50% off your purchase",
            imageName: "coupon_50",
            couponCode: "Carto50",
            discountPercentage: 50
        ),
    ]

    @State private var currentIndex: Int = 0
    @StateObject private var viewModel = DIContainer.shared.makeHomeViewModel()
    @EnvironmentObject private var router: Router<AppRoute>
    
    let timer = Timer.publish(
        every: 5,
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
                    Button {
                        router.push(to: .cart)
                    } label: {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color("PrimaryColor"))
                    }
                }
                TabView(selection: $currentIndex) {
                    ForEach(0..<ads.count, id: \.self) { index in
                        HomeBannerView(ad: ads[index])
                            .tag(index)
                    }
                }
                .frame(height: 200)
                .tabViewStyle(
                    PageTabViewStyle(indexDisplayMode: .never)
                )
                .overlay(alignment: .bottom) {
                    HStack(spacing: 8) {
                        ForEach(0..<ads.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color("PrimaryColor") : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .shadow(color: index == currentIndex ? Color("PrimaryColor").opacity(0.6) : .clear, radius: 3)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .onReceive(timer) { _ in
                    withAnimation {
                        currentIndex = (currentIndex + 1) % ads.count
                    }
                }

                HStack {
                    Text("brands_title")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("PrimaryColor"))

                    Spacer()

                    Button {
                        router.push(to: .brands)
                    } label: {
                        Text("see_more_btn")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                }

                HomeBrandView(
                    viewModel: viewModel.brandVM
                )

                Spacer(minLength: 20)

                Text("products_title")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color("PrimaryColor"))

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.productVM.products, id: \.id) { product in
                        Button {
                            router.push(to: .productDetails(product: product))
                        } label: {
                            ProductCard(product: product)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .task {
            await viewModel.loadAllData()
        }
    }
}
