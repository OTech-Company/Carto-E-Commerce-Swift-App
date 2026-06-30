//
//  CategoriesView.swift
//  Carto
//
//  Created by osama hosam on 28/06/2026.
//
//
//  CategoriesView.swift
//  Carto
//
//  Created by osama hosam on 28/06/2026.
//

import SwiftUI

@available(iOS 17.0, *)
struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    
    @State private var isSearchActive = false
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
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
                                    CategoryCardView(category: category)
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
                await viewModel.loadCategories()
            }
            .onAppear {
                Task { await viewModel.loadCategories() }
            }
        }
    }
}
