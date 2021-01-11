//
//  NetworkSessionMock.swift
//  TFS Chat Tests
//
//  Created by dmitry on 02.12.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

@testable import TFS_Chat
import Foundation

class NetworkSessionMock: NetworkSessionProtocol {
    var data: Data?
    var error: Error?
    var callsCount = 0

    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void) {
        callsCount += 1
        completionHandler(data, error)
    }
}
