//
//  CustomCategoryNavigationBar.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import SwiftUI

struct CustomCategoryNavigationBar: View {
    @Binding var isSearchActive: Bool
    @Binding var searchText: String
    var isSearchFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(spacing: 12) {
            if !isSearchActive {
                Text("Categories")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#2B7FD4"))
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
                            isSearchFieldFocused.wrappedValue = true
                        }
                    }
                
                if isSearchActive {
                    TextField("Search...", text: $searchText)
                        .focused(isSearchFieldFocused)
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
                        isSearchFieldFocused.wrappedValue = false
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
