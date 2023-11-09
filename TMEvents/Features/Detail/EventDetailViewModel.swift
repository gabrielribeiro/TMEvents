//
//  EventDetailViewModel.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

class EventDetailViewModel {
    
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    private(set) var event: Event?
    
    init(
        favoritesRepository: FavoritesRepositoryProtocol = DependencyContainer.shared.resolve(type: FavoritesRepositoryProtocol.self)!
    ) {
        self.favoritesRepository = favoritesRepository
    }
    
    func setEvent(_ event: Event) {
        self.event = event
    }
    
    func toggleFavorite() {
        guard let eventId = event?.id else {
            return
        }
        
        favoritesRepository.toggleFavoriteStatus(forEventWithId: eventId)
    }
    
    func isEventFavorited() -> Bool {
        guard let eventId = event?.id else {
            return false
        }
        
        return favoritesRepository.isEventFavorited(withId: eventId)
    }
}
