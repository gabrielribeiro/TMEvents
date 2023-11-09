//
//  EventDetailViewControllerUITests.swift
//  TMEventsUITests
//
//  Created by Gabriel Ribeiro on 09/11/23.
//

import XCTest

final class EventDetailViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testEventDetailViewElements() throws {
        let tableView = app.tables["EventsTableView"]
        XCTAssertTrue(tableView.exists)

        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)

        firstCell.tap()

        let detailViewController = app.navigationBars["Event info"]
        XCTAssertTrue(detailViewController.exists)
        
        let eventDetailView = app.otherElements["EventDetailView"]
        
        XCTAssertTrue(eventDetailView.exists, "The event detail view should be visible.")
        
        let eventNameLabel = eventDetailView.staticTexts["EventTitleLabelIdentifier"]
        let eventDateLabel = eventDetailView.staticTexts["EventDateLabelIdentifier"]
        let eventVenueLabel = eventDetailView.staticTexts["EventVenueLabelIdentifier"]
        let eventCityLabel = eventDetailView.staticTexts["EventLocationLabelIdentifier"]
        let eventImageView = eventDetailView.images["EventImageView"]
        
        XCTAssertTrue(eventNameLabel.exists, "Event name label should be visible.")
        XCTAssertTrue(eventDateLabel.exists, "Event date label should be visible.")
        XCTAssertTrue(eventVenueLabel.exists, "Event venue label should be visible.")
        XCTAssertTrue(eventCityLabel.exists, "Event city label should be visible.")
        XCTAssertTrue(eventImageView.exists, "Event image view should be visible.")
    }
    
    func testToggleFavoriteButton() throws {
        let tableView = app.tables["EventsTableView"]
        XCTAssertTrue(tableView.exists)

        let firstCell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)

        firstCell.tap()

        let detailViewController = app.navigationBars["Event info"]
        XCTAssertTrue(detailViewController.exists)
        
        let favoriteButton = app.navigationBars.buttons["FavoriteButton"]
        
        favoriteButton.tap()
    }
}
