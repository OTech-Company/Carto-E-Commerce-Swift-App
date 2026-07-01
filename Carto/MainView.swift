//
//  ContentView.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            makeCategoryListScreen()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Categories")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourits")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.tint(Color("PrimaryColor"))
    }
}

extension MainView {
    @ViewBuilder
    func makeCategoryListScreen() -> some View {
        let repository = ServiceLocator.shared.resolveCategoryRepository()
        let useCase = GetCategoryUseCase(repository: repository)
        let viewModel = CategoryListViewModel(getCategoryUseCase: useCase, fetchSubcategoriesUseCase: useCase)
        
        if #available(iOS 17.0, *) {
            CategoryListView(viewModel: viewModel)
        } else {
            Text("Please upgrade to iOS 17.")
        }
    }
}
