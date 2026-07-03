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
        return results.map {
            FavoriteItem(id: Int($0.id), title: $0.title ?? "", imageURL: $0.imageURL ?? "",
                         price: $0.price, compareAtPrice: $0.compareAtPrice,
                         savedAt: $0.savedAt ?? Date())
        }
    }

    func isFavorite(productId: Int) -> Bool {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", productId)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func save(_ item: FavoriteItem) {
        let entity = CDFavoriteItem(context: context)
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.imageURL = item.imageURL
        entity.price = item.price
        entity.compareAtPrice = item.compareAtPrice ?? 0
        entity.savedAt = item.savedAt
        CoreDataStack.shared.saveContext()
    }

    func delete(productId: Int) {
        let request: NSFetchRequest<CDFavoriteItem> = CDFavoriteItem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", productId)
        if let object = try? context.fetch(request).first {
            context.delete(object)
            CoreDataStack.shared.saveContext()
        }
    }
}
