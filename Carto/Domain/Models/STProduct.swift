import Foundation

struct STProduct: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String?
    let vendor: String?
    let productType: String?
    let handle: String
    let tags: [String]
    let variants: [STVariant]
    let images: [STImage]
    let options: [STOption]

    var mainImageURL: String? {
        images.first?.url
    }

    var imageURL: String {
        mainImageURL ?? ""
    }

    var price: Double {
        Double(variants.first?.price ?? "") ?? 0
    }

    var compareAtPrice: Double? {
        guard let value = variants.first?.compareAtPrice else { return nil }
        return Double(value)
    }

    var displayPrice: String {
        guard let price = variants.first?.price else { return "N/A" }
        return "$\(price)"
    }

    var discountPercentage: Int? {
        guard let compareAtPrice, compareAtPrice > price else { return nil }
        let discount = (compareAtPrice - price) / compareAtPrice * 100
        return Int(discount.rounded())
    }

    var sizes: [String] {
        options.first(where: { $0.name.lowercased() == "size" })?.values ?? []
    }

    var colors: [String] {
        options.first(where: { $0.name.lowercased() == "color" })?.values ?? []
    }
}

struct STVariant: Identifiable, Equatable {
    let id: String
    let merchandiseId: String
    let title: String
    let price: String
    let compareAtPrice: String?
    let sku: String?
    let availableForSale: Bool
    let currencyCode: String
}

struct STImage: Identifiable, Equatable {
    let id: String?
    let url: String
    let altText: String?
}

struct STOption: Identifiable, Equatable {
    let id: String?
    let name: String
    let values: [String]
}
