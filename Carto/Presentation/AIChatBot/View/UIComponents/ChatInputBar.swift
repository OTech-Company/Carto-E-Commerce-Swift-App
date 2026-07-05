//
//  ChatInputBar.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//


//
//  ChatInputBar.swift
//  Carto
//

import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    var onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                HStack {
                    TextField("Ask anything...", text: $text)
                        .font(.system(size: 15))
                    
                    Image(systemName: "waveform")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .glassCardStyle(cornerRadius: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(LinearGradient(colors: [.cyan.opacity(0.4), .blue.opacity(0.4)], startPoint: .leading, endPoint: .trailing), lineWidth: 1)
                )
                
                Button(action: onSend) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .padding(12)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            Text("powered by Carto AI")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .padding(.top, 4)
        }
    }
}