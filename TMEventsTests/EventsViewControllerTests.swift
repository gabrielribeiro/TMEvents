@testable import TMEvents
import XCTest

@MainActor
final class EventsViewControllerTests: XCTestCase {
    
    var viewController: EventsViewController!
    var viewModelMock: EventsViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        viewModelMock = EventsViewModelMock()
        viewController = EventsViewController(viewModel: viewModelMock)
    }

    override func tearDown() {
        viewModelMock = nil
        viewController = nil
        
        super.tearDown()
    }

    func testViewDidLoad() {
        // Given
        
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertEqual(viewController.title, "Simple TM Events List")
        XCTAssertNotNil(viewController.tableView)
        XCTAssertEqual(viewModelMock.delegate, viewController)
    }

    func testViewDidAppear() {
        // Given
        
        // When
        viewController.viewDidAppear(true)
        
        // Then
        XCTAssertTrue(viewModelMock.fetchDataCalled)
    }
}

class EventsViewModelMock: EventsViewModel {
    var fetchDataCalled = false
    
    override func fetchData(searchText: String? = nil, page: Int = 0) {
        super.fetchData(searchText: searchText, page: page)
        fetchDataCalled = true
    }
}
