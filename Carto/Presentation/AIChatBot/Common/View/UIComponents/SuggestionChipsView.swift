//
//  SuggestionChipsView.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import SwiftUI

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

struct SuggestionChipsView: View {
    let suggestions: [String]
    var onSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(suggestions, id: \.self) { text in
                    ChipButton(text: text, action: onSelect)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}
