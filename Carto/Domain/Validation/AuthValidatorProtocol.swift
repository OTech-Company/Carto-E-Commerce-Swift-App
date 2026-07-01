//
//  AuthValidatorProtocol.swift
//  Carto
//
//  Created by Mohamed Ayman on 28/06/2026.
//

import Foundation

protocol AuthValidatorProtocol {
    func validateEmail(
        email: String
    ) throws
    
    func validatePassword(
        password: String
    ) throws
    
    func validateName(
        name: String
    ) throws
}
