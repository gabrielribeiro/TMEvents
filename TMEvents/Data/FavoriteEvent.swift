//
//  FavoriteEvent.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation
import CoreData

@objc(FavoriteEvent)
class FavoriteEvent: NSManagedObject {
    @NSManaged var id: String
    
    class func newFavorite(withId id: String, in context: NSManagedObjectContext) -> FavoriteEvent {
        let item = FavoriteEvent(context: context)
        item.id = id
        return item
    }
    
    public class func fetchRequest() -> NSFetchRequest<FavoriteEvent> {
        return NSFetchRequest<FavoriteEvent>(entityName: "FavoriteEvent")
    }
}
