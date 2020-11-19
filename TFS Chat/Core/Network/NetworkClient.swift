//
//  NetworkClient.swift
//  TFS Chat
//
//  Created by dmitry on 19.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

protocol NetworkClientProtocol {
    
    func sendRequest<Parser: ParserProtocol>(url: String, parser: Parser, completion: @escaping(Parser.Model) -> Void)
}

class NetworkClient: NetworkClientProtocol {
    
    let session = URLSession.shared
    
    func sendRequest<Parser: ParserProtocol>(url: String, parser: Parser, completion: @escaping(Parser.Model) -> Void) {
        
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let parsedModel: Parser.Model = parser.parse(data: data) else {
                return
            }
            completion(parsedModel)
        }
        dataTask.resume()
    }
}
