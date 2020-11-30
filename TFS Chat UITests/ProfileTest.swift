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
    
    func testTextInputFieldsCount() throws {
        let expectedCount = 2
        let defaultTimeout = 3.0
        let app = XCUIApplication()
        app.launch()
        
        let profileLogo = app.otherElements["profileLogo"]
        _ = profileLogo.waitForExistence(timeout: defaultTimeout)
        profileLogo.tap()
        _ = app.navigationBars["My Profile"].waitForExistence(timeout: defaultTimeout)
        
        let actualCount = calculateTextInputFieldsCount(for: app)
        XCTAssertTrue(actualCount == expectedCount,
                      "Expected \(expectedCount) text elements, but was \(actualCount)")
    }
    
    private func calculateTextInputFieldsCount(for app: XCUIApplication) -> Int {
        var textViewsCount = app.textViews.count
        for i in 0..<app.textViews.count {
            let element = app.textViews.element(boundBy: i)
            if element.label != "" {
                textViewsCount -= 1
                //each line with line break counts as separate textView with label, so we need to ignore such textViews
            }
        }
        
        return textViewsCount + app.textFields.count
    }
    
}
