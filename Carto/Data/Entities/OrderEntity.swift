import Foundation

struct OrderEntity: Identifiable {
    let id: Int
    let orderNumber: String
    let formattedDate: String
    let totalPrice: String
    let currency: String
    let financialStatus: OrderFinancialStatus
    let fulfillmentStatus: OrderFulfillmentStatus
    let itemCount: Int
    let items: [OrderItemEntity]
}

struct OrderItemEntity: Identifiable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String
}

enum OrderFinancialStatus: String {
    case paid = "Paid"
    case pending = "Pending"
    case refunded = "Refunded"
    case unknown = "Unknown"
}

enum OrderFulfillmentStatus: String {
    case fulfilled = "Fulfilled"
    case unfulfilled = "Unfulfilled"
    case partial = "Partially Fulfilled"
    case restocked = "Restocked"
}


import Foundation

extension OrderDTO {
    func toDomain() -> OrderEntity {
        // Safe Date Parsing Strategy
        var displayDate = "Unknown Date"
        if let processedAt = self.processedAt {
            // Shopify timezone layout handles standard ISO strings or custom offsets
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            if let date = formatter.date(from: processedAt) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                outputFormatter.timeStyle = .none
                displayDate = outputFormatter.string(from: date)
            } else {
                // Fail-safe manual fallback formatting split if custom offsets act up
                let components = processedAt.components(separatedBy: "T")
                if let firstComponent = components.first {
                    displayDate = firstComponent
                }
            }
        }
        
        // Financial status safety mapping (handling "paid", "pending", "refunded")
        let mappedFinancial = OrderFinancialStatus(rawValue: self.financialStatus?.capitalized ?? "") ?? .unknown
        
        // Fulfillment status safety mapping
        let mappedFulfillment: OrderFulfillmentStatus
        switch self.fulfillmentStatus?.lowercased() {
        case "fulfilled":
            mappedFulfillment = .fulfilled
        case "partial":
            mappedFulfillment = .partial
        case "restocked":
            mappedFulfillment = .restocked
        default:
            mappedFulfillment = .unfulfilled
        }
        
        // Mapping sub-components (Line Items)
        let mappedItems = self.lineItems?.map { dto in
            OrderItemEntity(
                id: dto.id,
                title: dto.title,
                quantity: dto.quantity,
                price: dto.price ?? "0.00"
            )
        } ?? []
        
        let totalItemsPurchased = mappedItems.reduce(0) { $0 + $1.quantity }
        
        return OrderEntity(
            id: self.id,
            orderNumber: "#\(self.orderNumber)",
            formattedDate: displayDate,
            totalPrice: self.totalPrice ?? "0.00",
            currency: self.currency ?? "USD",
            financialStatus: mappedFinancial,
            fulfillmentStatus: mappedFulfillment,
            itemCount: totalItemsPurchased,
            items: mappedItems
        )
    }
}
