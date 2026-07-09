//
//  CategoriesView.swift
//  Carto
//
//  Created by osama hosam on 28/06/2026.

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    
    @State private var isSearchActive = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    

    
    var body: some View {
        VStack(spacing: 0) {
            CustomCategoryNavigationBar(
                isSearchActive: $isSearchActive,
                searchText: $searchText,
                isSearchFieldFocused: $isSearchFieldFocused
            )
            
            Group {
                switch viewModel.state {
                case .loading:
                    Spacer()
                    ProgressView()
                    Spacer()
                    
                case .error(let message):
                    Spacer()
                    Text(message).foregroundColor(.red)
                    Spacer()
                    
                case .success(let allCategories):
                    let displayCategories = allCategories.filter {
                        let title = $0.title.lowercased()
                        return title != "home page" &&
                               title != "hydrogen" &&
                               (searchText.isEmpty || title.contains(searchText.lowercased()))
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(displayCategories) { category in
                                Button {
                                    router.push(
                                        to: .categoryProducts(
                                            categoryId: String(category.id),
                                            categoryName: category.title
                                        )
                                    )
                                } label: {
                                    CategoryCardView(category: category)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground).opacity(0.3))
        .task {
                    if case .success = viewModel.state {
                        return // Exit early, data is already loaded!
                    }
                    
                    await viewModel.loadCategories()
 
                }
    }
}
