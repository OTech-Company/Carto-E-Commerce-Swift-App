//
//  HomeSearchHeader.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI

struct HomeSearchHeader: View {
    @ObservedObject var viewModel : HomeViewModel
    @Binding var searchText: String
    @FocusState var isSearchFocused: Bool
    @EnvironmentObject private var router: Router<AppRoute>
    
    var body: some View {
        HStack(spacing: 12) {
            if !isSearchFocused {
                HStack(spacing: 4) {
                    Image("app_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                
                TextField("Search...", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .focused($isSearchFocused)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            
            if isSearchFocused {
                Button("Cancel") {
                    searchText = ""
                    isSearchFocused = false
                }
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.accentColor)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                Button {
                    viewModel.openCart {
                        router.push(to: .cart)
                    }
                } label: {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .animation(.easeInOut(duration: 0.25), value: isSearchFocused)
    }
}
