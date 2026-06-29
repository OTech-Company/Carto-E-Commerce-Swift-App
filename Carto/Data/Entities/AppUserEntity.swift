struct AppUserEntity {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let avatarUrl: String?
    let accessToken: String
    let addresses: [AddressEntity]
}

