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
    
    // Strict 2-column layout structure
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header Bar matching your target design
                customNavigationBar
                
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
                            return title != "home page" && title != "hydrogen" && (searchText.isEmpty || title.contains(searchText.lowercased()))
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
    
    // MARK: - Navigation Header View
    private var customNavigationBar: some View {
        HStack(spacing: 12) {
            if !isSearchActive {
                Text("Categories")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            isSearchActive = true
                            isSearchFieldFocused = true
                        }
                    }
                
                if isSearchActive {
                    TextField("Search...", text: $searchText)
                        .focused($isSearchFieldFocused)
                        .foregroundColor(.black)
                        .transition(.opacity)
                    
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
            }
            .frame(maxWidth: isSearchActive ? .infinity : 44)
            .background(isSearchActive ? Color(.systemGray6) : Color.clear)
            .clipShape(Capsule())
            
            if isSearchActive {
                Button("Cancel") {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        searchText = ""
                        isSearchActive = false
                        isSearchFieldFocused = false
                    }
                }
                .foregroundColor(.black)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

// MARK: - Fixed Layout Card View
struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // FIXED: Enforced geometric clipping block preventing parent row blowouts
            Group {
                if let url = category.imageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            // CRITICAL: Force image boundaries directly
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 130)
                            .clipped()
                    } placeholder: {
                        Color(.systemGray6)
                            .frame(height: 130)
                            .overlay(ProgressView())
                    }
                } else {
                    Color(.systemGray6)
                        .frame(height: 130)
                        .overlay(Image(systemName: "photo").foregroundColor(.gray))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding([.top, .horizontal], 8)
            
            // Text Header
            Text(category.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(.horizontal, 14)
            
            // Sub-action label link
            HStack(spacing: 4) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
                
                Text("Shop Now")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .frame(maxWidth: .infinity) // Respects the flexible GridItem size constraints explicitly
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
