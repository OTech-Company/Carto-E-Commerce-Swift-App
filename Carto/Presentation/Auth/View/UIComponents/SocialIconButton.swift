//
//  SocialIconButton.swift
//  Carto
//
//  Created by Mohamed Ayman on 27/06/2026.
//

import SwiftUI

struct SocialIconButton: View {
    let iconName: String
    var isSystem: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if isSystem {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                } else {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 24, height: 24)
            .padding(12)
            .background(Color.white)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color(.systemGray5), lineWidth: 1)
            )
        }
    }
}
