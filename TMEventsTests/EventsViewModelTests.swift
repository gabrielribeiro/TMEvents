@testable import TMEvents
import XCTest

@MainActor
final class EventsViewModelTests: XCTestCase {
    
    var delegateMock: EventsViewControllerDelegateMock!
    var mockNetworkService: MockNetworkService!
    var eventsAPIMock: EventsAPI!
    var favoritesRepositoryMock: FavoritesRepositoryMock!
    var sut: EventsViewModel!

    override func setUp() {
        super.setUp()
        
        delegateMock = EventsViewControllerDelegateMock()
        mockNetworkService = MockNetworkService()
        eventsAPIMock = EventsAPI(networkService: mockNetworkService)
        favoritesRepositoryMock = FavoritesRepositoryMock()
        
        sut = EventsViewModel(
            eventsAPI: eventsAPIMock,
            favoritesRepository: favoritesRepositoryMock
        )
        sut.delegate = delegateMock
    }

    override func tearDown() {
        delegateMock = nil
        eventsAPIMock = nil
        favoritesRepositoryMock = nil
        sut = nil
        
        super.tearDown()
    }

    func testFetchData() throws {
        // Given
        mockNetworkService.dataToReturn = try GetEventsResponse.sampleData().toStubData()

        // When
        sut.fetchData()

        // Then
        XCTAssertTrue(delegateMock.loadingDidChangeCalled)
        XCTAssertTrue(delegateMock.didFetchWithSuccessCalled)
        XCTAssertFalse(delegateMock.didFailCalled)
    }
    
    func testFetchDataWithSearchText() throws {
        // Given
        mockNetworkService.dataToReturn = try GetEventsResponse.sampleData().toStubData()

        // When
        sut.fetchData(searchText: "Taylor Swift")

        // Then
        XCTAssertTrue(delegateMock.loadingDidChangeCalled)
        XCTAssertTrue(delegateMock.didFetchWithSuccessCalled)
        XCTAssertFalse(delegateMock.didFailCalled)
        XCTAssertEqual(sut.searchText, "Taylor Swift")
    }

    func testRetry() throws {
        // Given
        mockNetworkService.dataToReturn = try GetEventsResponse.sampleData().toStubData()
        
        // When
        sut.retry()

        // Then
        XCTAssertTrue(delegateMock.loadingDidChangeCalled)
        XCTAssertTrue(delegateMock.didFetchWithSuccessCalled)
        XCTAssertFalse(delegateMock.didFailCalled)
    }

    func testIsEventFavorited() {
        // Given
        let event = Event.sampleData()
        favoritesRepositoryMock.isEventFavoritedReturnValue = true
        
        // When
        let isFavorited = sut.isEventFavorited(event)
        
        // Then
        XCTAssertTrue(favoritesRepositoryMock.isEventFavoritedCalled)
        XCTAssertTrue(isFavorited)
    }
}

class EventsViewControllerDelegateMock: NSObject, EventsViewControllerDelegate {
    var loadingDidChangeCalled = false
    var didFetchWithSuccessCalled = false
    var didFailCalled = false

    func loadingDidChange(loading: Bool) {
        loadingDidChangeCalled = true
    }

    func didFetchWithSuccess() {
        didFetchWithSuccessCalled = true
    }

    func didFail(with error: Error?) {
        didFailCalled = true
    }
}
