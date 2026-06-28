//
//  OnboardingData.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//


import Foundation
import SwiftUI


struct OnboardingPage {
    let outlinedText: [String]
    let boldText: String
    let imageName: String
    let imageOnTop: Bool
}

enum OnboardingData {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            outlinedText: ["DISCOVER", "THOUSANDS OF"],
            boldText: "PRODUCTS.",
            imageName: "onboarding_browse",
            imageOnTop: false
        ),
        OnboardingPage(
            outlinedText: ["ADD TO CART", "WITH"],
            boldText: "ONE TAP.",
            imageName: "onboarding_cart",
            imageOnTop: true
        ),
        OnboardingPage(
            outlinedText: ["FAST &", "SECURE"],
            boldText: "CHECKOUT.",
            imageName: "onboarding_pay",
            imageOnTop: false
        )
    ]
}
