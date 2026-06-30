//
//  CategoriesView.swift
//  Carto
//
//  Created by Nadin Ahmed on 28/06/2026.
//

import SwiftUI

@available(iOS 17.0, *)
struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading Categories...")
                    
                case .error(let message):
                    ContentUnavailableView {
                        Label("Something went wrong", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            Task { await viewModel.loadCategories() }
                        }
                    }
                    
                case .success(let categories):
                    if categories.isEmpty {
                        ContentUnavailableView("No Categories Found", systemImage: "tray")
                    } else {
                        List(categories) { category in
                            CategoryRowView(category: category)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Categories")
            .task {
                await viewModel.loadCategories()
            }
        }
    }
}

// MARK: - Supporting Row View
struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Image
            if let url = category.imageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.1)
                }
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                // Fallback placeholder if image is nil
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: "square.dashed")
                            .foregroundColor(.gray)
                    )
            }
            
            // Category Details
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !category.description.isEmpty {
                    Text(category.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text("\(category.totalProducts) items")
                    .font(.caption)
                    .foregroundColor(.accentColor)
                    .padding(.top, 2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}


