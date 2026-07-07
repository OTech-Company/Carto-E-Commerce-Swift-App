import Foundation

struct UserFirestoreDTO {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let shopifyCustomerId: String?
    let customerAccessToken: String?

    var asDictionary: [String: Any] {
        var dict: [String: Any] = [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
        if let shopifyCustomerId { dict["shopifyCustomerId"] = shopifyCustomerId }
        if let customerAccessToken { dict["customerAccessToken"] = customerAccessToken }
        return dict
    }

    init(
        uid: String,
        firstName: String,
        lastName: String,
        email: String,
        shopifyCustomerId: String? = nil,
        customerAccessToken: String? = nil
    ) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.shopifyCustomerId = shopifyCustomerId
        self.customerAccessToken = customerAccessToken
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
        self.shopifyCustomerId = dictionary["shopifyCustomerId"] as? String
        self.customerAccessToken = dictionary["customerAccessToken"] as? String
    }
}
