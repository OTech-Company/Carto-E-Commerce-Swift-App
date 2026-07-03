//
//  String+HTML.swift
//  Carto
//
//  Created by Manona on 01/07/2026.
//

import Foundation

extension String {
    func strippingHTMLTags() -> String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    func capitalizedFirstLetterOnly() -> String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst().lowercased()
    }
}
