//
//  OrderEntity.swift
//  Carto
//
//  Created by Osama Abdellatif on 01/07/2026.
//

import Foundation

enum OrderFinancialStatus: String, Codable, Hashable {
    case paid = "Paid"
    case pending = "Pending"
    case refunded = "Refunded"
    case unknown = "Unknown"
}

enum OrderFulfillmentStatus: String, Codable, Hashable {
    case fulfilled = "Fulfilled"
    case unfulfilled = "Unfulfilled"
    case partial = "Partially Fulfilled"
    case restocked = "Restocked"
}

struct OrderItemEntity: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String
    
    // Hash based on the unique line item database id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OrderItemEntity, rhs: OrderItemEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

struct OrderEntity: Identifiable, Codable, Hashable {
    let id: Int
    let orderNumber: String
    let formattedDate: String
    let totalPrice: String
    let currency: String
    let financialStatus: OrderFinancialStatus
    let fulfillmentStatus: OrderFulfillmentStatus
    let itemCount: Int
    let items: [OrderItemEntity]
    
    // Hash based on the unique order database id
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OrderEntity, rhs: OrderEntity) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OrderDTO {
    func toDomain() -> OrderEntity {
        // Safe Date Parsing Strategy
        var displayDate = "Unknown Date"
        if let processedAt = self.processedAt {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            if let date = formatter.date(from: processedAt) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateStyle = .medium
                outputFormatter.timeStyle = .none
                displayDate = outputFormatter.string(from: date)
            } else {
                let components = processedAt.components(separatedBy: "T")
                if let firstComponent = components.first {
                    displayDate = firstComponent
                }
            }
        }
        
        let mappedFinancial = OrderFinancialStatus(rawValue: self.financialStatus?.capitalized ?? "") ?? .unknown
        
        // Fulfillment status safety mapping
        let mappedFulfillment: OrderFulfillmentStatus
        switch self.fulfillmentStatus?.lowercased() {
        case "fulfilled":
            mappedFulfillment = .fulfilled
        case "partial", "partially_fulfilled":
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
            orderNumber: self.orderNumber.description,
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
