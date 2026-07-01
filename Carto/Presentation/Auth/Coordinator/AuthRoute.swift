//
//  AuthRoute.swift
//  Carto
//
//  Created by Mohamed Ayman on 01/07/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case login
    case register
    case verification(email: String)
    case verificationSuccess
    case forgotPassword
    case forgotPasswordSuccess
}
