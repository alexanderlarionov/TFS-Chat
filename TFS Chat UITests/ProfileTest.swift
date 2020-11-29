//
//  TFS_ChatUITests.swift
//  TFS ChatUITests
//
//  Created by dmitry on 29.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import XCTest

class ProfileTest: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testTextFieldsCount() throws {
        let expectedCount = 2
        let defaultTimeout = 3.0
        let app = XCUIApplication()
        app.launch()
        
        let profileLogo = app.otherElements["profileLogo"]
        _ = profileLogo.waitForExistence(timeout: defaultTimeout)
        profileLogo.tap()
        _ = app.navigationBars["Profile"].waitForExistence(timeout: defaultTimeout)
        
        let actualCount = app.textFields.count + app.textViews.count
        XCTAssertTrue(actualCount == expectedCount,
                      "Expected \(expectedCount) text elements, but was \(actualCount)")
    }
    
}
