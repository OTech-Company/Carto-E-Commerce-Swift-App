//
//  SuggestionChipsView.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//


//
//  SuggestionChipsView.swift
//  Carto
//

import SwiftUI

struct SuggestionChipsView: View {
    let suggestions: [String]
    var onSelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // First Chunk Dynamic Row
            HStack(spacing: 8) {
                if suggestions.indices.contains(0) { ChipButton(text: suggestions[0], action: onSelect) }
                if suggestions.indices.contains(1) { ChipButton(text: suggestions[1], action: onSelect) }
            }
            // Second Chunk Dynamic Row
            HStack(spacing: 8) {
                if suggestions.indices.contains(2) { ChipButton(text: suggestions[2], action: onSelect) }
                if suggestions.indices.contains(3) { ChipButton(text: suggestions[3], action: onSelect) }
            }
            // Remaining Items Row
            if suggestions.count > 4 {
                HStack(spacing: 8) {
                    ForEach(suggestions[4..<suggestions.count], id: \.self) { text in
                        ChipButton(text: text, action: onSelect)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ChipButton: View {
    let text: String
    var action: (String) -> Void
    
    var body: some View {
        Button(action: { action(text) }) {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}