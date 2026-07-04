//
//  ContentView.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//
import SwiftUI

@available(iOS 17.0, *)
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
    }

    @ViewBuilder
    private func makeFavoritesScreen() -> some View {
        FavoritesView()
    }
}

@available(iOS 17.0, *)
extension ContentView {
    @MainActor @ViewBuilder
    func makeCategoryListScreen() -> some View {
        let repository = ServiceLocator.shared.resolveCategoryRepository()
        let useCase = GetCategoryUseCase(repository: repository)
        let viewModel = CategoryListViewModel(getCategoryUseCase: useCase, fetchSubcategoriesUseCase: useCase)

        CategoryListView(viewModel: viewModel)
    }

    @ViewBuilder
    func makeSettingsScreen() -> some View {
        SettingsView()
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
