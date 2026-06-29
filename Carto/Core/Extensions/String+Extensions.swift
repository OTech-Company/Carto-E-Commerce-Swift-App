//
//  String+Extensions.swift
//  Carto
//
//  Created by Mohamed Ayman on 28/06/2026.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        let regex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return wholeMatch(of: regex) != nil
    }

    var isStrongPassword: Bool {
        let regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/
        return wholeMatch(of: regex) != nil
    }

    var isWeakPassword: Bool {
        !isStrongPassword
    }

    var isValidName: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)

        let regex = #"^[A-Za-z]+(?:[ '-][A-Za-z]+)*$"#

        return trimmed.count >= 2 &&
               trimmed.count <= 50 &&
               trimmed.range(of: regex, options: .regularExpression) != nil
    }
}
import Foundation

extension String {

    var isValidEmail: Bool {
        let regex = /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return wholeMatch(of: regex) != nil
    }

    var isStrongPassword: Bool {
        let regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/
        return wholeMatch(of: regex) != nil
    }

    var isWeakPassword: Bool {
        !isStrongPassword
    }
    
    var isValidName: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)

        let regex = #"^[A-Za-z]+(?:[ '-][A-Za-z]+)*$"#

        return trimmed.count >= 2 &&
               trimmed.count <= 50 &&
               trimmed.range(of: regex, options: .regularExpression) != nil
    }
}

