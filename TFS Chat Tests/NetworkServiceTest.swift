//
//  TFS_Chat_Tests.swift
//  TFS Chat Tests
//
//  Created by dmitry on 01.12.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

@testable import TFS_Chat
import XCTest

class NetworkServiceTest: XCTestCase {
    
    func testRequestAndParsing() throws {
        
        //Arrange
        let validJsonString = """
        {
            "total": 21811,
            "hits": [
                {
                    "id": 2696947,
                    "previewURL": "https://cdn.pixabay.com/photo/2017/08/30/12/45/girl-2696947_150.jpg",
                    "webformatURL": "https://pixabay.com/get/54e6dc454356ab14f1dc846096293e7f1636d6e6524c704f752973d29f4fc450_640.jpg",
                },
                {
                    "previewURL": "https://cdn.pixabay.com/photo/2015/06/22/08/40/child-817373_150.jpg",
                    "webformatURL": "https://pixabay.com/get/5ee1d2404d51b10ff3d8992cc621367d1c37dde44e50774973277ddc954ccd_640.jpg",
                }
            ]
        }
        """
        
        let sessionMock = NetworkSessionMock()
        sessionMock.data = Data(validJsonString.utf8)
        let networkClient = NetworkClient(session: sessionMock)
        let networkService = NetworkService(networkClient: networkClient)
        
        var completionSuccessfull: Bool!
        
        //Act
        networkService.loadImagesData { result in
            switch result {
            case .success:
                completionSuccessfull = true
            case .failure:
                completionSuccessfull = false
            }
        }
        
        //Assert
        XCTAssertEqual(sessionMock.callsCount, 1)
        XCTAssertTrue(completionSuccessfull, "Request is not finished successfully")
    }
    
}
