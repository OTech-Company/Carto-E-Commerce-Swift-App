//
//  View+OutlinedText.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//

import SwiftUI

struct OutlinedText: View {

    let text: String
    let fontSize: CGFloat

    var body: some View {
        ZStack {
            Text(text).font(.system(size: fontSize, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y: -1.5)
            Text(text).font(.system(size: fontSize, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y: -1.5)
            Text(text).font(.system(size: fontSize, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x: -1.5, y:  1.5)
            Text(text).font(.system(size: fontSize, weight: .black)).foregroundStyle(.white.opacity(0.35)).offset(x:  1.5, y:  1.5)
            Text(text).font(.system(size: fontSize, weight: .black)).foregroundStyle(Color(hex: "#2B7FD4"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
