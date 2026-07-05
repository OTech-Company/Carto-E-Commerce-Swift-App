//
//  ChatBubbleView.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//


//
//  ChatBubbleView.swift
//  Carto
//

import SwiftUI

struct ChatBubbleView: View {
    let text: String
    let isUser: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(isUser ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isUser ? Color.blue : Color.white.opacity(0.6))
                .glassCardStyle(cornerRadius: 18, isEnabled: !isUser)
                .cornerRadius(18)
                .frame(maxWidth: isUser ? .infinity : 280, alignment: isUser ? .trailing : .leading)
            
            if !isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}