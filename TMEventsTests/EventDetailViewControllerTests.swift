@testable import TMEvents
import XCTest

@MainActor
final class EventDetailViewControllerTests: XCTestCase {
    
    var sut: EventDetailViewController!
    var viewModelMock: EventDetailViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        viewModelMock = EventDetailViewModelMock()
        sut = EventDetailViewController(viewModel: viewModelMock)
    }
    
    override func tearDown() {
        viewModelMock = nil
        sut = nil
        
        super.tearDown()
    }
    
    func testViewController_SetsUpSubviewsCorrectly() throws {
        XCTAssertNotNil(sut.scrollView)
        XCTAssertNotNil(sut.contentView)
        XCTAssertNotNil(sut.imageView)
        XCTAssertNotNil(sut.eventNameLabel)
        XCTAssertNotNil(sut.eventDateLabel)
        XCTAssertNotNil(sut.eventVenueLabel)
        XCTAssertNotNil(sut.eventCityLabel)
    }
    
    
    func testConfigure() {
        // Given
        let event = Event.sampleData()
        
        // When
        sut.configure(for: event)
        
        // Then
        XCTAssertTrue(viewModelMock.didSetEventCalled)
        XCTAssertEqual(sut.eventNameLabel.text, event.name)
        XCTAssertEqual(sut.eventDateLabel.text, event.formattedDate)
        XCTAssertEqual(sut.eventVenueLabel.text, event.venueName)
        XCTAssertEqual(sut.eventCityLabel.text, event.location)
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem?.image)
    }
    
    func testToggleFavoriteButtonTapped() {
        // Given
        
        // When
        sut.toggleFavoriteButtonTapped()
        
        // Then
        XCTAssertTrue(viewModelMock.toggleFavoriteCalled)
    }
}

class EventDetailViewModelMock: EventDetailViewModel {
    var didSetEventCalled = false
    var toggleFavoriteCalled = false
    
    override func setEvent(_ event: Event) {
        super.setEvent(event)
        didSetEventCalled = true
    }

    override func toggleFavorite() {
        super.toggleFavorite()
        toggleFavoriteCalled = true
    }
}
