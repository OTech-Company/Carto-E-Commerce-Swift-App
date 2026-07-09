import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    let ads: [ADEntity] = [
        ADEntity(title: "10% Discount", description: "Get 10% off your purchase", imageName: "coupon_10", couponCode: "Carto10", discountPercentage: 10),
        ADEntity(title: "20% Discount", description: "Get 20% off your purchase", imageName: "coupon_20", couponCode: "Carto20", discountPercentage: 20),
        ADEntity(title: "50% Discount", description: "Get 50% off your purchase", imageName: "coupon_50", couponCode: "Carto50", discountPercentage: 50)
    ]

    @State private var currentIndex: Int = 0
    @State private var isShowingAISheet: Bool = false
    @State private var searchText: String = ""
    @StateObject private var viewModel = DIContainer.shared.makeHomeViewModel()
    @EnvironmentObject private var router: Router<AppRoute>
    
    @FocusState var isSearchFocused: Bool

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]

    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HomeSearchHeader(viewModel: viewModel,searchText: $searchText, isSearchFocused: _isSearchFocused)
                    
                    if isSearchFocused {
                        HomeSearchView(searchText: searchText, columns: columns)
                    } else {
                        defaultHomeContentView
                    }
                }
                .padding(.horizontal, 16)
            }
            
            if !isSearchFocused {
                HomeFloatingAIButton(isShowingAISheet: $isShowingAISheet)
            }
        }
        .animate(value: isSearchFocused)
        .task {
            await viewModel.loadAllData()
        }
        .sheet(isPresented: $isShowingAISheet) {
            HomeAISheetView(isShowingAISheet: $isShowingAISheet)
        }
        .environmentObject(viewModel)
        .alert("Login Required", isPresented: $viewModel.showAuthAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login") {
                Task{
                   await viewModel.logout()
                }
            }
        } message: {
            Text("Please log in to add items to your cart or manage your favorites.")
        }
    }
    
    // MARK: - Default Content View
    private var defaultHomeContentView: some View {
        Group {
            HomePromoBannerCarousel(ads: ads, currentIndex: $currentIndex, timer: timer)
            HomeBrandSectionHeader()
            
            HomeBrandView(viewModel: viewModel.brandVM)
            
            Spacer(minLength: 5)
            
            HomeProductGrid(columns: columns)
        }
        .transition(.opacity)
    }
}
