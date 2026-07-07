//
//  CurrencyFormatter.swift
//  Carto
//
//  Created by Mohamed Ayman on 05/07/2026.
//


import Foundation

enum CurrencyFormatter {

    static func format(_ amount: String, currencyCode: String) -> String {
        guard let decimalValue = Decimal(string: amount) else {
            return "\(amount) \(currencyCode)"
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode

        return formatter.string(from: decimalValue as NSDecimalNumber) ?? "\(amount) \(currencyCode)"
    }
}
