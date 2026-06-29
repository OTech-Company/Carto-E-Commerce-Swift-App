//
//  ValidationError.swift
//  Carto
//
//  Created by Mohamed Ayman on 28/06/2026.
//

import Foundation

enum AuthValidationError: LocalizedError {
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case weakPassword
    case passwordsDoNotMatch
    case emptyName
    case invalidName
    
    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Email is required."

        case .invalidEmail:
            return "Please enter a valid email."

        case .emptyPassword:
            return "Password is required."

        case .weakPassword:
            return "Password must be at least 8 characters."

        case .passwordsDoNotMatch:
            return "Passwords do not match."
            
        case .emptyName:
            return "Name is required."
            
        case .invalidName:
            return "Please enter a valid name."
        }
    }
}
