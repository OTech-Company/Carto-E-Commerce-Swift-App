//
//  OutfitItemBundleCard.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI
struct OutfitGridItemCard: View {
    let product: Product
    var onSelect: () -> Void
    
    @State private var isLiked: Bool = false
    @State private var isAddedToCart: Bool = false
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 6) {
                // Asset Canvas Frame Box
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6).opacity(0.7))
                        .aspectRatio(1.0, contentMode: .fit)
                    if let url = URL(string: product.imageURL) , !product.imageURL.isEmpty {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .tint(.secondary)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                case .failure:
                                                    Image(systemName: "bag.fill")
                                                        .font(.system(size: 24))
                                                        .foregroundColor(.secondary.opacity(0.4))
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                            .padding(12)
                                        } else {
                                            Image(systemName: "bag.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.secondary.opacity(0.4))
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                    
                    // Controls overlay floating perfectly along bottom margins
                    HStack {
                        Button(action: { isLiked.toggle() }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(isLiked ? .red : .secondary)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Button(action: { isAddedToCart.toggle() }) {
                            Image(systemName: isAddedToCart ? "checkmark.circle.fill" : "bag.badge.plus")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(isAddedToCart ? .green : .primary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                
                // Metadata details stacked cleanly beneath asset frame
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text("by \(product.vendor)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Text(product.displayPrice)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 1)
                }
                .padding(.horizontal, 4)
            }
        }
        .buttonStyle(.plain)
    }
}
