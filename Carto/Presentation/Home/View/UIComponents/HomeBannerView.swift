//
//  HomeBannerView.swift
//  Carto
//
//  Created by Nadin Ahmed on 27/06/2026.
//

import SwiftUI

struct HomeBannerView: View {
    let ad: ADEntity
    @ObservedObject private var cartStore = CartStateStore.shared

    private var isClaimed: Bool {
        cartStore.suggestedCouponCode == ad.couponCode
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(ad.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text(ad.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text(ad.description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                
                Button {
                    withAnimation {
                        cartStore.setCoupon(ad.couponCode)
                    }
                } label: {
                    Text(isClaimed ? "Offer Claimed " : "Get Offer")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isClaimed ? Color.green : Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
                .disabled(isClaimed)
            }
            .padding(.leading, 24)
            .padding(.bottom, 32) 
        }
        .frame(height: 200)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
