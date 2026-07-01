import Foundation

struct CategoryDTO: Codable {
    let id: Int
    let title: String
    let handle: String?
    let bodyHtml: String?
    let image: ImageDTO?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case handle
        case bodyHtml = "body_html"
        case image
    }
}

struct ImageDTO: Codable {
    let src: String?            
}
