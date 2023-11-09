@testable import TMEvents
import XCTest

@MainActor
final class EventDetailViewModelTests: XCTestCase {
    
    var sut: EventDetailViewModel!
    var favoritesRepositoryMock: FavoritesRepositoryMock!

    override func setUp() {
        super.setUp()
        
        favoritesRepositoryMock = FavoritesRepositoryMock()
        sut = EventDetailViewModel(favoritesRepository: favoritesRepositoryMock)
    }

    override func tearDown() {
        favoritesRepositoryMock = nil
        sut = nil
        super.tearDown()
    }
    
    func testSetData() {
        // Given
        let event = Event.sampleData()
        
        // When
        sut.setEvent(event)
        
        // Then
        XCTAssertEqual(sut.event, event)
    }

    
    func testIsEventFavorited() {
        // Given
        let event = Event.sampleData()
        sut.setEvent(event)
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
        sut.setEvent(event)
        
        // When
        sut.toggleFavorite()
        
        // Then
        XCTAssertFalse(favoritesRepositoryMock.isEventFavoritedCalled)
        XCTAssertTrue(favoritesRepositoryMock.toggleFavoriteStatusCalled)
    }
}
