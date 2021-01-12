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
    /// Я бы заменил хранение и настройку константы PIXABAY_API_KEY на более удобное;
    /// Например Environment Variables или Arguments Passed on Launch (я предпочитаю первое);
    
    
    /// Вообще, NetworkService который в себе инкапсулирует baseURL несет сомнительную пользу;
    /// Я бы предложил сделать его параметром в конструкторе и заполнять из фабрики (ass_embly);
    
    
    /// Для формирования урлов из набора параметров рекомендую изучить и использовать NSURLComponents;
    
    
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
