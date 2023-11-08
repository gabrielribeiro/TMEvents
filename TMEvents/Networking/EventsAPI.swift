//
//  EventsAPI.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

typealias GetEventsResponse = TMResponse<EventsResponse>

class EventsAPI {
    
    enum APIError: Error {
        case invalidURL
    }
    
    // TODO: Move to On Demand Resources or any other safe place before go live
    private static let apiKey = "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX"
    
    private static let defaultURLString = "https://app.ticketmaster.com/discovery/v2/"
    
    private let urlString: String
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = DependencyContainer.shared.resolve(type: NetworkServiceProtocol.self)!,
        urlString: String = EventsAPI.defaultURLString
    ) {
        self.networkService = networkService
        self.urlString = urlString
    }
    
    func getEvents(
        keyword: String? = nil,
        page: Int? = nil,
        success: @escaping ((GetEventsResponse) -> Void),
        fail: @escaping ((Error?) -> Void)
    ) throws  -> URLSessionDataTask {
        guard var url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        url.append(path: "events.json")
        
        var queryItems: [URLQueryItem] = [
            .init(name: "apikey", value: EventsAPI.apiKey)
        ]
        
        if let keyword = keyword {
            queryItems.append(.init(name: "keyword", value: keyword))
        }
        
        if let page = page {
            queryItems.append(.init(name: "page", value: String(page)))
        }
        
        url.append(queryItems: queryItems)
        
        return networkService.request(GetEventsResponse.self, url: url) { eventsResponse, response, error in
            guard let eventsResponse = eventsResponse, error == nil else {
                fail(error)
                
                return
            }
            
            success(eventsResponse)
        }
    }
}
