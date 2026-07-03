import Foundation

struct Category: Identifiable {
    let id: String
    let title: String
    let description: String
    let imageURL: URL?
    let totalProducts: Int
}

extension Category {
    init(from dto: CategoryDTO) {
        self.id = String(dto.id)               
        self.title = dto.title
        self.description = dto.bodyHtml ?? ""
        self.imageURL = URL(string: dto.image?.src ?? "")
        self.totalProducts = 0
    }
}
