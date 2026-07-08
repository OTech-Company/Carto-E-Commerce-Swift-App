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
    @State private var isShowingAISheet: Bool = false // State tracking the AI feature modal sheet
    @State private var searchText: String = "" // State tracking search queries
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
        ZStack(alignment: .bottomTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header Block containing Logo, Middle Search Bar, and Cart action
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image("app_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                        }
                        
                        // Top Middle: Search Bar Field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                            
                            TextField("Search...", text: $searchText)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .clipShape(Capsule())
                        
                        // Top Right: Cart Trigger Button
                        Button {
                            router.push(to: .cart)
                        } label: {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    
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
                                    .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.5))
                                    .frame(width: 8, height: 8)
                                    .shadow(color: index == currentIndex ? Color.accentColor.opacity(0.6) : .clear, radius: 3)
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
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)

                        Spacer()

                        Button {
                            router.push(to: .brands)
                        } label: {
                            Text("see_more_btn")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.accentColor)
                        }
                    }

                    HomeBrandView(
                        viewModel: viewModel.brandVM
                    )

                    Spacer(minLength: 5)

                    Text("products_title")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)

                    switch viewModel.productVM.state {
                    case .loading, .idle:
                        LoadingView(width: .infinity)
                            .padding(.top, 40)
                    case .failure(let error):
                        ErrorView(width: .infinity, message: error.localizedDescription)
                            .padding(.top, 40)
                    case .success(let products):
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(products, id: \.id) { product in
                                Button {
                                    router.push(to: .productDetails(product: product))
                                } label: {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            // MARK: - Floating AI Assistant Action Trigger
            Button(action: {
                isShowingAISheet = true
            }) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
        .task {
            await viewModel.loadAllData()
        }
        .sheet(isPresented: $isShowingAISheet) {
            AIFeatureSheet {
                isShowingAISheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .aiChat)
                }
            } onNavigateToComparison: {
                isShowingAISheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .aiComparison)
                }
            } onNavigateToOutfit: {
                isShowingAISheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .aiOutfit)
                }
            } onNavigateToImageSearch: {
                isShowingAISheet = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .imageSearch)
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}
