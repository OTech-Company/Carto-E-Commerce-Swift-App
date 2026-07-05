//
//  ContentView.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            makeHomeScreen()
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            makeCategoryListScreen()
                .tabItem { Label("Categories", systemImage: "square.grid.2x2.fill") }
            
            makeFavoritesScreen()
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
            
            makeSettingsScreen()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Color("PrimaryColor"))
    }
    
    // MARK: - Tab Factories
    @ViewBuilder
    private func makeHomeScreen() -> some View {
        HomeView()
            .withRouter { route in
                routeDestination(for: route)
            }
    }

    @ViewBuilder
    private func makeFavoritesScreen() -> some View {
        FavoritesView()
    }
}

extension ContentView {
    @MainActor @ViewBuilder
    func makeCategoryListScreen() -> some View {
        let repository = ServiceLocator.shared.resolveCategoryRepository()
        let useCase = GetCategoryUseCase(repository: repository)
        let viewModel = CategoryListViewModel(getCategoryUseCase: useCase, fetchSubcategoriesUseCase: useCase)

        CategoryListView(viewModel: viewModel)
            .withRouter { route in
                routeDestination(for: route)
            }
    }

    @ViewBuilder
    func makeSettingsScreen() -> some View {
        SettingsView()
    }

    @MainActor
    private func routeDestination(for route: AppRoute) -> AnyView {
        switch route {
        case .brands:
            return AnyView(BrandsScreen(
                viewModel: HomeBrandsViewModel(useCase: DIContainer.shared.makeBrandsUseCase())
            ))
        case .brandProducts(let brandId, let brandName):
            return AnyView(ProductsView(
                brandID: brandId,
                viewModel: DIContainer.shared.makeCategoryProductViewModel()
            )
            .navigationTitle(brandName))
        case .categoryProducts(let categoryId, let categoryName):
            return AnyView(ProductsView(
                categoryId: categoryId,
                viewModel: DIContainer.shared.makeCategoryProductViewModel()
            )
            .navigationTitle(categoryName))
        case .productDetails(let product):
            return AnyView(ProductsInfoView(product: product))
        }
    }
    
//    func makeOrderHistoryScreen() -> some View {
//            let repository = ServiceLocator.shared.resolveOrderRepository()
//            let useCase = GetOrderHistoryUseCase(repository: repository)
//            let viewModel = OrderHistoryViewModel(getOrderHistoryUseCase: useCase)
//
//            if #available(iOS 17.0, *) {
//                OrderHistoryView(viewModel: viewModel)
//            } else {
//                Text("Please upgrade to iOS 17.")
//            }
//        }
}
