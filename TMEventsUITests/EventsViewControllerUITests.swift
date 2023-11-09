//
//  EventsViewControllerUITests.swift
//  TMEventsUITests
//
//  Created by Gabriel Ribeiro on 09/11/23.
//

import XCTest

final class EventsViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testTableView() {
        let app = XCUIApplication()
        app.launch()

        let tableView = app.tables["EventsTableView"]
        XCTAssertTrue(tableView.exists, "The events table view should exist.")

        let cells = tableView.cells
        expectation(for: NSPredicate(format: "count > 0"), evaluatedWith: cells, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)

        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)

            let eventTitleLabel = firstCell.staticTexts["EventTitleLabelIdentifier"]
            let eventDateLabel = firstCell.staticTexts["EventDateLabelIdentifier"]
            let eventVenueLabel = firstCell.staticTexts["EventVenueLabelIdentifier"]
            let eventLocationLabel = firstCell.staticTexts["EventLocationLabelIdentifier"]
            
            XCTAssert(eventTitleLabel.exists, "Event title label should exist.")
            XCTAssert(eventDateLabel.exists, "Event date label should exist.")
            XCTAssert(eventVenueLabel.exists, "Event venue label should exist.")
            XCTAssert(eventLocationLabel.exists, "Event location label should exist.")

            XCTAssertFalse(eventTitleLabel.label.isEmpty, "Event title label should have text.")
            XCTAssertFalse(eventDateLabel.label.isEmpty, "Event date label should have text.")
            XCTAssertFalse(eventVenueLabel.label.isEmpty, "Event venue label should have text.")
            XCTAssertFalse(eventLocationLabel.label.isEmpty, "Event location label should have text.")
        }
    }
    
//    func testSearchFunctionality() {
//        let searchField = app.searchFields["EventsSearchField"]
//        XCTAssertTrue(searchField.exists, "The search field should exist.")
//
//        searchField.tap()
//        searchField.typeText("Taylor Swift")
//
//        app.keyboards.buttons["Search"].tap()
//
//        let tableView = app.tables["EventsTableView"]
//        let cells = tableView.cells
//        expectation(for: NSPredicate(format: "count > 0"), evaluatedWith: cells, handler: nil)
//        waitForExpectations(timeout: 10, handler: nil)
//    }
    
    func testTappingOnFirstRowShouldPushDetail() {
        let tableView = app.tables["EventsTableView"]
        XCTAssertTrue(tableView.exists)

        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)

        firstCell.tap()

        let detailViewController = app.navigationBars["Event info"]
        XCTAssertTrue(detailViewController.exists)
    }
}
