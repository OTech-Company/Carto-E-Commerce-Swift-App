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
    func delete(productId: Int)
}

final class FavoritesLocalDataSource: FavoritesLocalDataSourceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
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
        CoreDataStack.shared.saveContext()
    }

    func delete(productId: Int) {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productId))
        if let objects = try? context.fetch(request) {
            objects.forEach { context.delete($0) }
            CoreDataStack.shared.saveContext()
        }
    }
}
