//
//  ApiServiceTest.swift
//  TFS Chat Tests
//
//  Created by dmitry on 03.12.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

@testable import TFS_Chat
import XCTest

class GCDDataManagerTest: XCTestCase {
    
    func testProfileInfoSaved() throws {
        //Arrange
        let mock = FileStorageMock()
        let service = GCDDataManager(fileStorage: mock)
        let info = "some profile info"
        let expectation = self.expectation(description: "Service complete async saving")
        
        //Act
        service.saveInfo(value: info,
                         completion: { expectation.fulfill() },
                         failure: {})
        waitForExpectations(timeout: 3, handler: nil)
        
        //Assert
        XCTAssertEqual(mock.callsCount, 1)
        XCTAssertEqual(mock.fileName, mock.profileInfoFile)
        XCTAssertEqual(mock.savedData, info)
    }
    
}
