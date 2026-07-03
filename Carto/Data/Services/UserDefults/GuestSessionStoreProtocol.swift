//
//  GuestSessionStoreProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

protocol GuestSessionStoreProtocol {
    var isGuest: Bool { get }
    func setGuest(_ isGuest: Bool)
}


