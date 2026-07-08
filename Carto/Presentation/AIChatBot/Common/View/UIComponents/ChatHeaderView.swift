//
//  ChatHeaderView.swift
//  Carto
//
//  Created by Osama Hosam on 05/07/2026.
//

import SwiftUI

struct ChatHeaderView: View {
    var title : String
    var onBackTap: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 12) {
            // MARK: - Native Back Navigation Trigger
            Button(action: {
                if let onBackTap = onBackTap {
                    onBackTap()
                } else {
                    dismiss() 
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.trailing, 4)
            
            Text(title)
                .font(.headline)
            
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Live")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundColor(.indigo)
                .shadow(color: .indigo.opacity(0.4), radius: 6)
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.3))
    }
}
