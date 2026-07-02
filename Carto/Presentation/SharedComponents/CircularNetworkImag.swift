//
//  CircularNetworkImag.swift
//  Carto
//
//  Created by Nadin Ahmed on 02/07/2026.
//

import SwiftUI

struct CircularNetworkImag: View {
    var width: CGFloat = 80
    var height: CGFloat = 80
    var imagURL: String = ""
    
    var body: some View {
        AsyncImage(url: URL(string: imagURL)) { phase in
            switch phase {
            case .empty:
                Image("app_logo")
                    .resizable()
                    .scaledToFill()

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                Image("app_logo")
                    .resizable()
                    .scaledToFill()

            @unknown default:
                Image("app_logo")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: height)
        .clipShape(Circle())
    }
}

//#Preview {
//    CircularNetworkImag()
//}
