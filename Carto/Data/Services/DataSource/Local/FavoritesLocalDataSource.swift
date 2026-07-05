//
//  FavoritesLocalDataSource.swift
//  Carto
//
//  Created by Manona on 03/07/2026.
//

import CoreData

protocol FavoritesLocalDataSourceProtocol {
    func fetchAll() -> [FavoriteItem]
    func isFavorite(productId: Int) -> Bool
    func save(_ item: FavoriteItem)
    func saveAll(_ items: [FavoriteItem]) async
    func delete(productId: Int)
    func delete(productIds: [Int]) async
    func deleteAll() async
}

final class FavoritesLocalDataSource: FavoritesLocalDataSourceProtocol {
    private let context: NSManagedObjectContext
    private let stack: CoreDataStack

    init(context: NSManagedObjectContext = CoreDataStack.shared.context, stack: CoreDataStack = .shared) {
        self.context = context
        self.stack = stack
    }

    func fetchAll() -> [FavoriteItem] {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]
        let results = (try? context.fetch(request)) ?? []
        return results.compactMap { entity in
            guard let data = entity.productData,
                  let product = try? JSONDecoder().decode(Product.self, from: data) else {
                return nil
            }
            return FavoriteItem(
                id: Int(entity.id),
                product: product,
                savedAt: entity.savedAt ?? Date()
            )
        }
    }

    func isFavorite(productId: Int) -> Bool {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productId))
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func save(_ item: FavoriteItem) {
        delete(productId: item.id)
        guard let data = try? JSONEncoder().encode(item.product) else { return }
        let entity = CDFavoriteItem(context: context)
        entity.id = Int64(item.id)
        entity.productData = data
        entity.savedAt = item.savedAt
        stack.saveContext()
    }

    func saveAll(_ items: [FavoriteItem]) async {
        guard !items.isEmpty else { return }
        await withCheckedContinuation { continuation in
            stack.performBackgroundTask { bgContext in
                let ids = items.map { NSNumber(value: $0.id) }
                let deleteRequest: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
                deleteRequest.predicate = NSPredicate(format: "id IN %@", ids)
                if let existing = try? bgContext.fetch(deleteRequest) {
                    existing.forEach { bgContext.delete($0) }
                }

                for item in items {
                    guard let data = try? JSONEncoder().encode(item.product) else { continue }
                    let entity = CDFavoriteItem(context: bgContext)
                    entity.id = Int64(item.id)
                    entity.productData = data
                    entity.savedAt = item.savedAt
                }

                if bgContext.hasChanges {
                    try? bgContext.save()
                }

                continuation.resume()
            }
        }
    }

    func delete(productId: Int) {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productId))
        if let objects = try? context.fetch(request) {
            objects.forEach { context.delete($0) }
            stack.saveContext()
        }
    }

    func delete(productIds: [Int]) async {
        guard !productIds.isEmpty else { return }
        await withCheckedContinuation { continuation in
            stack.performBackgroundTask { bgContext in
                let ids = productIds.map { NSNumber(value: $0) }
                let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
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
                let request: NSFetchRequest<NSFetchRequestResult> = CDFavoriteItem.fetchRequest()
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
