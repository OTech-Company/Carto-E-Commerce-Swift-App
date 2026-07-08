//
//  HomeBrandSectionHeader.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//


import SwiftUI

struct HomeBrandSectionHeader: View {
    @EnvironmentObject private var router: Router<AppRoute>
    
    var body: some View {
        HStack {
            Text("brands_title")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button {
                router.push(to: .brands)
            } label: {
                Text("see_more_btn")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
    }
}
