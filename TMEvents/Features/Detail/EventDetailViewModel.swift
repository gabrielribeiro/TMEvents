//
//  EventDetailViewModel.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

protocol EventDetailViewControllerDelegate: NSObject {
    func didSetData()
}

class EventDetailViewModel {
    
    enum RowType {
        case name, date, venue, location
        
        var title: String {
            switch self {
            case .name:
                return "Name"
            case .date:
                return "Date"
            case .venue:
                return "Vanue"
            case .location:
                return "Location"
            }
        }
    }
    
    struct Row {
        var value: String
        var rowType: RowType
    }
    
    weak var delegate: EventDetailViewControllerDelegate?
    
    private (set) var items: [Row] = []
    
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    private var event: Event?
    
    init(
        favoritesRepository: FavoritesRepositoryProtocol = DependencyContainer.shared.resolve(type: FavoritesRepositoryProtocol.self)!
    ) {
        self.favoritesRepository = favoritesRepository
    }
    
    func setData(for event: Event) {
        self.event = event
        
        items = [
            .init(value: event.name, rowType: .name)
        ]
        
        if let formattedDate = event.formattedDate {
            items.append(.init(value: formattedDate, rowType: .date))
        }
        
        if let venueName = event.venueName {
            items.append(.init(value: venueName, rowType: .venue))
        }
        
        if let location = event.location {
            items.append(.init(value: location, rowType: .location))
        }
        
        delegate?.didSetData()
    }
    
    func toggleFavorite() {
        guard let eventId = event?.id else {
            return
        }
        
        favoritesRepository.toggleFavoriteStatus(forEventWithId: eventId)
        
        delegate?.didSetData()
    }
    
    func isEventFavorited() -> Bool {
        guard let eventId = event?.id else {
            return false
        }
        
        return favoritesRepository.isEventFavorited(withId: eventId)
    }
}
