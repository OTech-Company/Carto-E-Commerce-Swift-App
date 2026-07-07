//
//  PrimaryButton.swift
//  Carto
//
//  Created by Nadin Ahmed on 05/07/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(
            title,
            action: {
                action()
            }
        )
        .padding()
        .background(Color("PrimaryColor"))
        .foregroundColor(.white)
        .font(.system(size: 18, weight: .bold))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
