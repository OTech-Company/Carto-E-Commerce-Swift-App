
// BannerDTO — used by Ads + Home
struct BannerDTO: Codable {
    let id: String
    let imageUrl: String
    let targetUrl: String?
    let title: String?
    let isActive: Bool
}
