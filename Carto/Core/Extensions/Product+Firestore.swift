//
//  Product+Firestore.swift
//  Carto
//
//  Created by Manona on 05/07/2026.
//

import Foundation

extension Product {
    var asFirestoreMap: [String: Any] {
        guard
            let data = try? JSONEncoder().encode(self),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [:] }
        return json
    }

    init?(firestoreMap map: [String: Any]) {
        guard
            let data = try? JSONSerialization.data(withJSONObject: map),
            let product = try? JSONDecoder().decode(Product.self, from: data)
        else { return nil }
        self = product
    }
}
