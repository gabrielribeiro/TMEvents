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
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchData() {
        
        delegate?.loadingDidChange(loading: true)
        
        do {
            try apiClient.getEvents { [weak self] eventsResponse in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.events = eventsResponse.embedded.events
                
                strongSelf.delegate?.loadingDidChange(loading: false)
                
                strongSelf.delegate?.didFetchWithSuccess()
            } fail: { [weak self] error in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.delegate?.loadingDidChange(loading: false)
                
                strongSelf.delegate?.didFail(with: error)
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
}
