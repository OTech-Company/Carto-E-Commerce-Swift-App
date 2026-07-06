//
//  ComparisonVisualHeader.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI

// MARK: - Subcomponent: Side-by-Side Visual Anchor
struct ComparisonVisualHeader: View {
    let p1: Product?
    let p2: Product?
    
    var body: some View {
        HStack(spacing: 0) {
            ProductMiniCard(product: p1)
            
            Text("VS")
                .font(.system(.caption, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(10)
                .background(Color(.systemGroupedBackground))
                .clipShape(Circle())
                .zIndex(1)
                .padding(.horizontal, -16)
            
            ProductMiniCard(product: p2)
        }
    }
}
