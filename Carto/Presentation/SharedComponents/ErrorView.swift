//
//  ErrorView.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct ErrorView: View {
    var width: CGFloat = 300
    var height: CGFloat = 250
    var message: String = "Something went wrong"

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.octagon.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)

            Text("oops_title")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: width, maxHeight: height)
    }
}
//
//#Preview {
//    ErrorView(retryAction: {})
//}
