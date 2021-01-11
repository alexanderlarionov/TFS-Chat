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
    
    func loadImagesData(completion: @escaping (Result<DataModel, Error>) -> Void)
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    let networkClient: NetworkClientProtocol
    let apiBaseUrl: String = {
        guard let apiKey = Bundle.main.infoDictionary?["PIXABAY_API_KEY"] as? String else {
            print("API Key not set for Pixabay")
            return ""
        }
        return "https://pixabay.com/api/?key=" + apiKey + "&q=icons&image_type=photo&per_page=150"
    }()
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func loadImagesData(completion: @escaping (Result<DataModel, Error>) -> Void) {
        networkClient.sendRequest(url: apiBaseUrl, parser: JsonParser(), completion: completion)
    }
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        networkClient.sendRequest(url: url, parser: ImageParser(), completion: completion)
    }
}
