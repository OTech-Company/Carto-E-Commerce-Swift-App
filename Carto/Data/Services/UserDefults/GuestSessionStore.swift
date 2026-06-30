//
//  GuestSessionStore.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

final class GuestSessionStore: GuestSessionStoreProtocol {

    private let key = "carto.isGuestSession"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isGuest: Bool {
        defaults.bool(forKey: key)
    }

    func setGuest(_ isGuest: Bool) {
        defaults.set(isGuest, forKey: key)
    }
}
