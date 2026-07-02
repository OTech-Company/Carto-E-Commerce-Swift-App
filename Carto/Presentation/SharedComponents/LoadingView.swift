//
//  LoadingScreen.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

import SwiftUI

struct LoadingView: View {
    var width: CGFloat = 200
    var height: CGFloat = 200

    var body: some View {
        VStack(spacing: 8) {
            ProgressView()
                .scaleEffect(1.5)
                .foregroundColor(Color("PrimaryColor"))

            Text("Loading...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: width, maxHeight: height)
    }
}

//#Preview {
//    LoadingView(width: 200, height: 200)
//}
