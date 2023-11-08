@testable import TMEvents
import XCTest
import CoreData

@MainActor
final class FavoritesRepositoryTests: XCTestCase {

    var favoritesRepository: FavoritesRepository!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()

        persistentContainer = createTestPersistentContainer()
        favoritesRepository = FavoritesRepository()
        favoritesRepository.persistentContainer = persistentContainer
    }

    override func tearDown() {
        super.tearDown()
        
        favoritesRepository = nil
        persistentContainer = nil
    }

    func testToggleFavoriteStatus() {
        // Given
        let eventId = "1"
        
        // When
        favoritesRepository.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertTrue(favoritesRepository.isEventFavorited(withId: eventId))
        
        // When
        favoritesRepository.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertFalse(favoritesRepository.isEventFavorited(withId: eventId))
    }

    func testIsEventFavorited() {
        // Given
        let eventId = "2"
        
        // When
        favoritesRepository.toggleFavoriteStatus(forEventWithId: eventId)
        
        // Then
        XCTAssertTrue(favoritesRepository.isEventFavorited(withId: eventId))
    }
}
