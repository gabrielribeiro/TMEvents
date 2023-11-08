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
    
    private let apiClient: APIClient
    
    private var dataTask: URLSessionDataTask?
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchData(searchText: String? = nil, page: Int = 0) {
        dataTask?.cancel()
        
        delegate?.loadingDidChange(loading: true)
        
        self.searchText = searchText
        
        do {
            self.dataTask = try apiClient.getEvents(keyword: searchText, page: page) { [weak self] eventsResponse in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.page = eventsResponse.page
                
                if strongSelf.page?.number == 0 {
                    strongSelf.events = eventsResponse.embedded?.events ?? []
                } else {
                    strongSelf.events.append(contentsOf: (eventsResponse.embedded?.events ?? []))
                }
                
                strongSelf.delegate?.loadingDidChange(loading: false)
                
                strongSelf.delegate?.didFetchWithSuccess()
            } fail: { [weak self] error in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.delegate?.loadingDidChange(loading: false)
                
                if let nsError = error as? NSError {
                    if nsError.domain == NSURLErrorDomain && nsError.code == -999 {
                        print("The request was cancelled.")
                    } else {
                        strongSelf.delegate?.didFail(with: error)
                    }
                } else {
                    strongSelf.delegate?.didFail(with: error)
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func fetchDataForNextPage() {
        guard let page = page else { return }
        
        let nextPageNumber = page.number + 1
        
        if nextPageNumber < page.totalPages {
            self.fetchData(
                searchText: searchText,
                page: nextPageNumber
            )
        }
    }
}
