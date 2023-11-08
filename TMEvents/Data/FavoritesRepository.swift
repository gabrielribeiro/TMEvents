//
//  FavoritesRepository.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation
import CoreData

protocol FavoritesRepositoryProtocol {
    func toggleFavoriteStatus(forEventWithId id: String)
    func isEventFavorited(withId id: String) -> Bool
}

class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private var cachedFavoriteEvents: [FavoriteEvent] = []
    
    init() {
        fetchFavoriteEvents()
    }
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TMEvents")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Favorite Event Management
    
    func toggleFavoriteStatus(forEventWithId id: String) {
        if let index = cachedFavoriteEvents.firstIndex(where: { $0.id == id }) {
            let favoriteEvent = cachedFavoriteEvents[index]
            viewContext.delete(favoriteEvent)
            cachedFavoriteEvents.remove(at: index)
        } else {
            // Event not found in cache, create a new one and mark it as favorite.
            let newFavoriteEvent = FavoriteEvent.newFavorite(withId: id, in: viewContext)
            cachedFavoriteEvents.append(newFavoriteEvent)
        }
        
        saveContext()
    }
    
    func isEventFavorited(withId id: String) -> Bool {
        return cachedFavoriteEvents.contains { $0.id == id }
    }
    
    // Fetch favorited events from Core Data and cache them.
    private func fetchFavoriteEvents() {
        let fetchRequest: NSFetchRequest<FavoriteEvent> = FavoriteEvent.fetchRequest()
        
        do {
            cachedFavoriteEvents = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching favorite events: \(error)")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
