//
//  CategoryCardView.swift
//  Carto
//
//  Created by Osama Hosam on 30/06/2026.
//

import SwiftUI

struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                if let url = category.imageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
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
            
            Text(category.title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(.horizontal, 14)
            
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
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
