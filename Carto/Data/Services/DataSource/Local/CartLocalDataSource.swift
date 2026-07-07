//
//  CartLocalDataSource.swift
//  Carto
//
//  Created by Manona on 06/07/2026.
//

import CoreData

protocol CartLocalDataSourceProtocol {
    func fetchAll() -> [CartItem]
    func save(_ item: CartItem)
    func saveAll(_ items: [CartItem]) async
    func delete(id: String)
    func delete(ids: [String]) async
    func deleteAll() async
}

final class CartLocalDataSource: CartLocalDataSourceProtocol {
    private let context: NSManagedObjectContext
    private let stack: CoreDataStack

    init(context: NSManagedObjectContext = CoreDataStack.shared.context, stack: CoreDataStack = .shared) {
        self.context = context
        self.stack = stack
    }

    func fetchAll() -> [CartItem] {
        let request: NSFetchRequest<CDCartItem> = CDCartItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
        let results = (try? context.fetch(request)) ?? []
        return results.compactMap { entity in
            guard let data = entity.productData,
                  let product = try? JSONDecoder().decode(Product.self, from: data),
                  let color = entity.selectedColor,
                  let size = entity.selectedSize else {
                return nil
            }
            return CartItem(
                product: product,
                selectedColor: color,
                selectedSize: size,
                quantity: Int(entity.quantity),
                savedAt: entity.savedAt ?? Date()
            )
        }
    }

    func save(_ item: CartItem) {
        delete(id: item.id)
        guard let data = try? JSONEncoder().encode(item.product) else { return }
        let entity = CDCartItem(context: context)
        entity.id = item.id
        entity.productData = data
        entity.selectedColor = item.selectedColor
        entity.selectedSize = item.selectedSize
        entity.quantity = Int64(item.quantity)
        entity.savedAt = item.savedAt
        stack.saveContext()
    }

    func saveAll(_ items: [CartItem]) async {
        guard !items.isEmpty else { return }
        await withCheckedContinuation { continuation in
            stack.performBackgroundTask { bgContext in
                let ids = items.map { $0.id }
                let deleteRequest: NSFetchRequest<CDCartItem> = CDCartItem.fetchRequest()
                deleteRequest.predicate = NSPredicate(format: "id IN %@", ids)
                if let existing = try? bgContext.fetch(deleteRequest) {
                    existing.forEach { bgContext.delete($0) }
                }

                for item in items {
                    guard let data = try? JSONEncoder().encode(item.product) else { continue }
                    let entity = CDCartItem(context: bgContext)
                    entity.id = item.id
                    entity.productData = data
                    entity.selectedColor = item.selectedColor
                    entity.selectedSize = item.selectedSize
                    entity.quantity = Int64(item.quantity)
                    entity.savedAt = item.savedAt
                }

                if bgContext.hasChanges {
                    try? bgContext.save()
                }

                continuation.resume()
            }
        }
    }

    func delete(id: String) {
        let request: NSFetchRequest<CDCartItem> = CDCartItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let objects = try? context.fetch(request) {
            objects.forEach { context.delete($0) }
            stack.saveContext()
        }
    }

    func delete(ids: [String]) async {
        guard !ids.isEmpty else { return }
        await withCheckedContinuation { continuation in
            stack.performBackgroundTask { bgContext in
                let request: NSFetchRequest<CDCartItem> = CDCartItem.fetchRequest()
                request.predicate = NSPredicate(format: "id IN %@", ids)
                if let objects = try? bgContext.fetch(request) {
                    objects.forEach { bgContext.delete($0) }
                }
                if bgContext.hasChanges {
                    try? bgContext.save()
                }
                continuation.resume()
            }
        }
    }

    func deleteAll() async {
        await withCheckedContinuation { continuation in
            stack.performBackgroundTask { bgContext in
                let request: NSFetchRequest<NSFetchRequestResult> = CDCartItem.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                deleteRequest.resultType = .resultTypeObjectIDs
                if let result = try? bgContext.execute(deleteRequest) as? NSBatchDeleteResult,
                   let deletedIds = result.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: deletedIds]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.context])
                }
                continuation.resume()
            }
        }
    }
}
