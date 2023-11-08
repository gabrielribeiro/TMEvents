@testable import TMEvents
import XCTest

@MainActor
final class EventDetailViewControllerTests: XCTestCase {
    
    var viewController: EventDetailViewController!
    var viewModelMock: EventDetailViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        viewModelMock = EventDetailViewModelMock()
        viewController = EventDetailViewController(viewModel: viewModelMock)
    }
    
    override func tearDown() {
        viewModelMock = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // Given
        let tableView = viewController.tableView
        
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertEqual(viewController.title, "Event info")
        XCTAssertEqual(viewModelMock.delegate, viewController)
        XCTAssertNotNil(tableView)
        XCTAssertEqual(tableView?.numberOfSections, 1)
        XCTAssertNotNil(tableView?.tableFooterView)
    }
    
    func testConfigure() {
        // Given
        let event = Event.sampleData()
        let mockImage = UIImage(systemName: "star")
        
        // When
        viewController.configure(for: event)
        
        // Then
        XCTAssertTrue(viewModelMock.didSetDataCalled)
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.image, mockImage)
    }
    
    func testToggleFavoriteButtonTapped() {
        // Given
        
        // When
        viewController.toggleFavoriteButtonTapped()
        
        // Then
        XCTAssertTrue(viewModelMock.toggleFavoriteCalled)
    }
    
    func testDidSetData() {
        // Given
        let event = Event.sampleData()
        viewController.configure(for: event)
        let tableView = viewController.tableView
        
        // When
        viewModelMock.setData(for: event)
        viewController.didSetData()
        
        // Then
        XCTAssertTrue(viewModelMock.didSetDataCalled)
        XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 4)
    }
}

class EventDetailViewModelMock: EventDetailViewModel {
    var didSetDataCalled = false
    var toggleFavoriteCalled = false

    override func setData(for event: Event) {
        super.setData(for: event)
        didSetDataCalled = true
    }

    override func toggleFavorite() {
        super.toggleFavorite()
        toggleFavoriteCalled = true
    }
}
