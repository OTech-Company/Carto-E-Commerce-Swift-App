//
//  SplashItem.swift
//  Carto
//
//  Created by Osama Hosam on 28/06/2026.
//


import Foundation


struct SplashItem: Identifiable {
    let id       = UUID()
    let x:        CGFloat
    let size:     CGFloat
    let delay:    Double
    let rotation: Double
    let fromTop:  Bool
}
