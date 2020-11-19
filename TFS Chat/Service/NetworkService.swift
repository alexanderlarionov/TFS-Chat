//
//  NetworkService.swift
//  TFS Chat
//
//  Created by dmitry on 19.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    
    func loadImagesData(completion: @escaping (DataModel) -> Void)
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    let networkClient: NetworkClientProtocol
    let apiBaseUrl = "https://pixabay.com/api/?key=19139831-67087a5068526f1d9fc406fc3&q=icons&image_type=photo&per_page=150"
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func loadImagesData(completion: @escaping (DataModel) -> Void) {
        networkClient.sendRequest(url: apiBaseUrl, parser: JsonParser(), completion: completion)
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        networkClient.sendRequest(url: url, parser: ImageParser(), completion: completion)
    }
}
