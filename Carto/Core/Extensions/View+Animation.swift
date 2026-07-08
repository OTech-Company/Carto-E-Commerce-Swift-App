//
//  View+Animation.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func animate(value: Bool) -> some View {
        self.animation(.easeInOut(duration: 0.2), value: value)
    }
}
