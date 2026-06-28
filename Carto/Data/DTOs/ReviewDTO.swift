// ReviewDTO
struct ReviewDTO: Codable {
    let id: String
    let author: String
    let rating: Double
    let body: String?
    let createdAt: String
}

