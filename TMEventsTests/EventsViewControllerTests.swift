@testable import TMEvents
import XCTest

@MainActor
final class EventsViewControllerTests: XCTestCase {
    
    var sut: EventsViewController!
    var viewModelMock: EventsViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        viewModelMock = EventsViewModelMock()
        sut = EventsViewController(viewModel: viewModelMock)
    }

    override func tearDown() {
        viewModelMock = nil
        sut = nil
        
        super.tearDown()
    }

    func testViewDidLoad() {
        // Given
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertEqual(sut.title, "Simple TM Events List")
        XCTAssertNotNil(sut.tableView)
        XCTAssertEqual(viewModelMock.delegate, sut)
    }

    func testViewDidAppear() {
        // Given
        
        // When
        sut.viewDidAppear(true)
        
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
