@testable import TMEvents
import XCTest

@MainActor
final class EventsAPITests: XCTestCase {
    
    func testGetEventsRealRequest() throws {
        
        let expectation = XCTestExpectation(description: "GET Events Request")
        
        let eventsAPI = EventsAPI()
        
        let _ = eventsAPI.getEvents { eventsResponse in
            
            let events = eventsResponse.embedded?.events ?? []
            
            XCTAssert(events.count > 0, "Events count: \(events.count)")
            
            expectation.fulfill()
        } fail: { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                XCTFail("Unexpected response")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetEventsSuccess() throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.dataToReturn = try GetEventsResponse.sampleData().toStubData()
        
        let eventsAPI = EventsAPI(networkService: mockNetworkService)
        
        let expectation = XCTestExpectation(description: "Success events response")
        
        let _ = eventsAPI.getEvents(success: { eventsResponse in
            XCTAssertEqual(eventsResponse.embedded?.events, [
                Event(
                    id: "A",
                    name: "SF49 x Miami Phins",
                    dates: .init(start: .init(dateTime: nil)),
                    eventData: nil,
                    images: []
                )
            ])
            
            expectation.fulfill()
        }, fail: { error in
            XCTFail("Wasn't supposed to fail")
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetEventsFail() throws {
        let mockNetworkService = MockNetworkService()
        mockNetworkService.errorToReturn = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        
        let eventsAPI = EventsAPI(networkService: mockNetworkService)
        
        let expectation = XCTestExpectation(description: "Failed events response")
        
        let _ = eventsAPI.getEvents(success: { _ in
            XCTFail("Wasn't supposed to succeed")
        }, fail: { error in
            let nsError = try! XCTUnwrap(error as? NSError)
            
            XCTAssertEqual(nsError.domain, "MockErrorDomain")
            XCTAssertEqual(nsError.code, 123)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}
