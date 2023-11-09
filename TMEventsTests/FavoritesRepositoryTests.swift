@testable import TMEvents
import XCTest
import CoreData

@MainActor
final class FavoritesRepositoryTests: XCTestCase {

    var sut: FavoritesRepository!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        persistentContainer = createTestPersistentContainer()
        sut = FavoritesRepository()
        sut.persistentContainer = persistentContainer
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
        persistentContainer = nil
    }

    func testToggleFavoriteStatus() {
        // Given
        let eventId = "1"
        
        // When
        sut.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertTrue(sut.isEventFavorited(withId: eventId))
        
        // When
        sut.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertFalse(sut.isEventFavorited(withId: eventId))
    }

    func testIsEventFavorited() {
        // Given
        let eventId = "2"
        
        // When
        sut.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertTrue(sut.isEventFavorited(withId: eventId))
    }
}
