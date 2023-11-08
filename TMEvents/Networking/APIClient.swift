//
//  APIClient.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import Foundation

typealias GetEventsResponse = TMResponse<EventsResponse>

class APIClient {
    
    enum APIError: Error {
        case invalidURL
    }
    
    private static let defaultURLString = "https://app.ticketmaster.com/discovery/v2/"
    private static let apiKey = "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX"
    
    private let urlString: String
    private let networkService: NetworkService
    
    init(
        networkService: NetworkService = TMNetworkService(),
        urlString: String = APIClient.defaultURLString
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
        
        var queryItems: [Foundation.URLQueryItem] = [
            .init(name: "apikey", value: APIClient.apiKey)
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
