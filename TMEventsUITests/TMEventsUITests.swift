//
//  TMEventsUITests.swift
//  TMEventsUITests
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import XCTest

final class TMEventsUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        super.setUp(
        )
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
