//
//  TestHelpers.swift
//  TMEventsTests
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

@testable import TMEvents
import Foundation

extension Event {
    static func sampleData() -> Event {
        return Event(
            id: "A",
            name: "SF49 x Miami Phins",
            dates: Dates(start:
                            StartDate(dateTime: Date(timeIntervalSince1970: 1609459200))
                        ),
            eventData: EventEmbedded(venues: [
                Venue(
                    id: "A",
                    name: "Stadium",
                    city: City(
                        name: "San Fracisco"
                    ),
                    state: State(
                        name: "California",
                        stateCode: "CA"
                    )
                )
            ]),
            images: []
        )
    }
}

extension GetEventsResponse {
    static func sampleData() -> GetEventsResponse {
        let eventsResponse = GetEventsResponse(
            embedded: .init(events: [
                Event.sampleData()
            ]),
            page: Page(
                size: 1,
                totalElements: 1,
                totalPages: 1,
                number: 0
            )
        )
        
        return eventsResponse
    }
}

extension Encodable {
    func toStubData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToReturn: Error?
    
    func request<T>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? where T : Decodable, T : Encodable {
        if let dataToReturn = dataToReturn {
            completionHandler(try? JSONDecoder().decode(type, from: dataToReturn), responseToReturn, errorToReturn)
        } else {
            completionHandler(nil, responseToReturn, errorToReturn)
        }
        
        return nil
    }
}

class FavoritesRepositoryMock: FavoritesRepositoryProtocol {
    
    var toggleFavoriteStatusCalled = false
    var isEventFavoritedCalled = false
    var isEventFavoritedReturnValue = false
    
    func toggleFavoriteStatus(forEventWithId id: String) {
        toggleFavoriteStatusCalled = true
    }
    
    func isEventFavorited(withId id: String) -> Bool {
        isEventFavoritedCalled = true
        return isEventFavoritedReturnValue
    }
}
