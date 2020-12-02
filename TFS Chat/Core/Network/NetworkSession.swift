//
//  UrlSession.swift
//  TFS Chat
//
//  Created by dmitry on 02.12.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

protocol NetworkSessionProtocol {
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSessionProtocol {
    
    func loadData(from url: URL,
                  completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, _, error) in
            completionHandler(data, error)
        }
        
        task.resume()
    }
}
