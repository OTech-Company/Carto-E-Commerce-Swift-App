//
//  User.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

struct User {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let isEmailVerified: Bool

    var fullName: String { "\(firstName) \(lastName)" }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.uid == rhs.uid
    }
}
