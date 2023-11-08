@testable import TMEvents
import XCTest

@MainActor
final class EventDetailViewModelTests: XCTestCase {
    
    var sut: EventDetailViewModel!
    var delegateMock: EventDetailViewControllerDelegateMock!
    var favoritesRepositoryMock: FavoritesRepositoryMock!

    override func setUp() {
        super.setUp()
        
        delegateMock = EventDetailViewControllerDelegateMock()
        favoritesRepositoryMock = FavoritesRepositoryMock()
        sut = EventDetailViewModel(favoritesRepository: favoritesRepositoryMock)
        sut.delegate = delegateMock
    }

    override func tearDown() {
        delegateMock = nil
        favoritesRepositoryMock = nil
        sut = nil
        super.tearDown()
    }

    func testSetData() {
        // Given
        let event = Event.sampleData()
        
        // When
        sut.setData(for: event)
        
        // Then
        XCTAssertEqual(sut.items.count, 4)
        
        XCTAssertEqual(sut.items[0].rowType, .name)
        XCTAssertEqual(sut.items[0].value, "SF49 x Miami Phins")
        
        XCTAssertEqual(sut.items[1].rowType, .date)
        XCTAssertEqual(sut.items[1].value, "DEC 31")
        
        XCTAssertEqual(sut.items[2].rowType, .venue)
        XCTAssertEqual(sut.items[2].value, "Stadium")
        
        XCTAssertEqual(sut.items[3].rowType, .location)
        XCTAssertEqual(sut.items[3].value, "San Fracisco, CA")
        
        XCTAssertTrue(delegateMock.didSetDataCalled)
    }
    
    func testIsEventFavorited() {
        // Given
        let event = Event.sampleData()
        sut.setData(for: event)
        favoritesRepositoryMock.isEventFavoritedReturnValue = true
        
        // When
        let isFavorited = sut.isEventFavorited()
        
        // Then
        XCTAssertTrue(favoritesRepositoryMock.isEventFavoritedCalled)
        XCTAssertTrue(isFavorited)
    }
    
    func testToggleFavorite() {
        // Given
        let event = Event.sampleData()
        sut.setData(for: event)
        
        // When
        sut.toggleFavorite()
        
        // Then
        XCTAssertFalse(favoritesRepositoryMock.isEventFavoritedCalled)
        XCTAssertTrue(favoritesRepositoryMock.toggleFavoriteStatusCalled)
        XCTAssertTrue(delegateMock.didSetDataCalled)
    }
}

class EventDetailViewControllerDelegateMock: NSObject, EventDetailViewControllerDelegate {
    var didSetDataCalled = false

    func didSetData() {
        didSetDataCalled = true
    }
}
