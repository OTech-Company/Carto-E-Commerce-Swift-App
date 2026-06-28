//
//  ProductSplashImage.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//
import SwiftUI

struct ProductSplashImage: View {

    let item: SplashItem
    let screen: CGRect
    let itemsVisible: Bool
    let itemsFallen: Bool

    // Match these exactly to your asset names in Assets.xcassets
    private let productImages = [
        "splash_shoe_1",        // Jordan gray
        "splash_shoe_2",        // Jordan red
        "splash_shoe_3",        // Jordan black
        "splash_shoe_4",        // Nike red
        "splash_headphones_1",  // Black headphones
        "splash_headphones_2",  // Gray headphones
        "splash_headphones_3",  // Cream headphones
        "splash_bag_1",         // Brown leather bag
        "splash_bag_2",         // Cream tote bag
        "splash_sunglasses_1",  // Black sunglasses
        "splash_sunglasses_2",  // Clear sunglasses
    ]

    private var imageName: String {
        let index = Int(item.x * 19 + (item.fromTop ? 0 : 5)) % productImages.count
        return productImages[index]
    }

    private var restingY: CGFloat {
        item.fromTop
            ? screen.height * 0.25     // upper scattered zone
            : screen.height * 0.78     // lower pile zone
    }

    private var startY: CGFloat {
        item.fromTop
            ? -item.size * 2
            : screen.height + item.size * 2
    }

    private var fallenY: CGFloat {
        screen.height + item.size + 150  // fully off screen bottom
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: item.size)
            .rotationEffect(.degrees(
                itemsFallen ? item.rotation * 2 : item.rotation
            ))
            .shadow(color: .black.opacity(0.12), radius: 8, x: 2, y: 4)
            .position(
                x: screen.width * item.x,
                y: itemsFallen
                    ? fallenY
                    : itemsVisible
                        ? restingY
                        : startY
            )
            .animation(
                itemsFallen
                    ? .interpolatingSpring(
                        mass: 1.3,
                        stiffness: 72,
                        damping: 7,
                        initialVelocity: 8
                      ).delay(item.delay * 0.4)
                    : .spring(
                        response: 0.6,
                        dampingFraction: 0.70
                      ).delay(item.delay),
                value: itemsFallen ? itemsFallen : itemsVisible
            )
    }
}
