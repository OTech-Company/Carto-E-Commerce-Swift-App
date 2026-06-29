//
//  AuthValidatorImpl.swift
//  Carto
//
//  Created by Mohamed Ayman on 28/06/2026.
//

import Foundation

struct AuthValidator: AuthValidatorProtocol {

    func validateEmail(email: String) throws {

        guard !email.isEmpty else {
            throw AuthValidationError.emptyEmail
        }
        
        guard email.isValidEmail else {
            throw AuthValidationError.invalidEmail
        }
    }

    func validatePassword(password: String) throws {
        
        guard !password.isEmpty else {
            throw AuthValidationError.emptyPassword
        }
        
        guard !password.isStrongPassword else {
            throw AuthValidationError.weakPassword
        }
    }
    
    func validateName(name: String) throws {
        guard !name.isEmpty else {
            throw AuthValidationError.emptyName
        }
        
        guard name.isValidName else {
            throw AuthValidationError.invalidName
        }
    }

}
