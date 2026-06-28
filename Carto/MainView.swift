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

            CategoriesView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Categories")
                }

            CartView()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.tint(Color("PrimaryColor"))
    }
}
