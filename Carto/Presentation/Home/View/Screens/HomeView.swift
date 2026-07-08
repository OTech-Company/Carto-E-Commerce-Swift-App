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
    @State private var isShowingAISheet: Bool = false // State tracking the AI feature modal sheet
    @StateObject private var viewModel = DIContainer.shared.makeHomeViewModel()
    @EnvironmentObject private var router: Router<AppRoute>
    
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
        ZStack(alignment: .bottomTrailing) {
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
                            router.push(to: .brands)
                        } label: {
                            Text("see more")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color("PrimaryColor"))
                        }
                    }

                    HomeBrandView(
                        viewModel: viewModel.brandVM
                    )

                    Spacer(minLength: 20)

                    Text("Products")
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
            
            // MARK: - Floating AI Assistant Action Trigger
            Button(action: {
                isShowingAISheet = true
            }) {
                Image(systemName: "sparkles.rectangle.stack.fill" /* Customize to match your specific asset or SF symbol */)
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
        }.sheet(isPresented: $isShowingAISheet) {
            AIFeatureSheet {
                // 1. Dismiss assistant sheet first
                isShowingAISheet = false
                
                // 2. Small delay to let sheet slide down completely before pushing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .aiChat)
                }
            } onNavigateToComparison: {
                isShowingAISheet = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    router.push(to: .aiComparison)
                }
            }onNavigateToOutfit:{
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
