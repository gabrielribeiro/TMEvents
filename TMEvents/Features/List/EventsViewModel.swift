//
//  EventsViewModel.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

protocol EventsViewControllerDelegate: NSObject {
    func didFail(with error: Error?)
    func didFetchWithSuccess()
    func loadingDidChange(loading: Bool)
}

class EventsViewModel {
    
    weak var delegate: EventsViewControllerDelegate?
    
    private (set) var events: [Event] = []
    private (set) var searchText: String?
    private (set) var page: Page?
    
    private var isFetchingNextPageData = false
    
    private let eventsAPI: EventsAPI
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    private var dataTask: URLSessionDataTask?
    
    init(
        eventsAPI: EventsAPI = DependencyContainer.shared.resolve(type: EventsAPI.self)!,
        favoritesRepository: FavoritesRepositoryProtocol = DependencyContainer.shared.resolve(type: FavoritesRepositoryProtocol.self)!
    ) {
        self.eventsAPI = eventsAPI
        self.favoritesRepository = favoritesRepository
    }
    
    func fetchData(searchText: String? = nil, page: Int = 0) {
        dataTask?.cancel()
        
        delegate?.loadingDidChange(loading: true)
        
        let newSearch = self.searchText != searchText
        
        self.searchText = searchText
        
        self.dataTask = eventsAPI.getEvents(keyword: searchText, page: page) { [weak self] eventsResponse in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.page = eventsResponse.page
            
            if strongSelf.page?.number == 0 || newSearch {
                strongSelf.events = eventsResponse.embedded?.events ?? []
            } else {
                strongSelf.events.append(contentsOf: (eventsResponse.embedded?.events ?? []))
            }
            
            strongSelf.isFetchingNextPageData = false
            
            strongSelf.delegate?.loadingDidChange(loading: false)
            
            strongSelf.delegate?.didFetchWithSuccess()
        } fail: { [weak self] error in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isFetchingNextPageData = false
            
            strongSelf.delegate?.loadingDidChange(loading: false)
            
            strongSelf.delegate?.didFail(with: error)
        }
    }
    
    func fetchDataForNextPage() {
        guard let page = page, !isFetchingNextPageData else { return }
        
        let nextPageNumber = page.number + 1
        
        if nextPageNumber < page.totalPages {
            self.isFetchingNextPageData = true
            
            self.fetchData(
                searchText: searchText,
                page: nextPageNumber
            )
        }
    }
    
    func retry() {
        self.fetchData(
            searchText: searchText,
            page: page?.number ?? 0
        )
    }
    
    func isEventFavorited(_ event: Event) -> Bool {
        return favoritesRepository.isEventFavorited(withId: event.id)
    }
}
