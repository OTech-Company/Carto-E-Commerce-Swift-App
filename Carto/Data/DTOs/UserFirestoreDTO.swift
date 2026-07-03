//
//  UserFirestoreDTO.swift
//  Carto
//
//  Created by Mohamed Ayman on 30/06/2026.
//

import Foundation

struct UserFirestoreDTO {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String

    var asDictionary: [String: Any] {
        [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
    }

    init(uid: String, firstName: String, lastName: String, email: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }

    init?(dictionary: [String: Any]) {
        guard
            let uid = dictionary["uid"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let email = dictionary["email"] as? String
        else {
            return nil
        }
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
