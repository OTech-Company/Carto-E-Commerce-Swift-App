struct AuthDTO: Codable {
    let accessToken: String
    let expiresAt: String
}

struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

struct RegisterRequestDTO: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
