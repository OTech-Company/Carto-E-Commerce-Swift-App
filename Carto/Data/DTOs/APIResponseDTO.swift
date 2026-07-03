struct APIResponseDTO<T: Codable>: Codable {
    let data: T?
    let errors: [String]?
    let userErrors: [UserErrorDTO]?
}

struct UserErrorDTO: Codable {
    let field: [String]?
    let message: String
}
