//
//  Parser.swift
//  TFS Chat
//
//  Created by dmitry on 19.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import UIKit

/// Я бы переименовал JsonParser -> DataModelParser
/// Суть класса не в том что он прасит JSON, а в том что на выходе получается DataModel

class JsonParser: ParserProtocol {
    typealias Model = DataModel
    
    func parse(data: Data) -> DataModel? {
        do {
            return try JSONDecoder().decode(DataModel.self, from: data)
        } catch {
            print("Error trying to convert data to JSON")
            return nil
        }
    }
}

struct DataModel: Decodable {
    let hits: [ImageData]
    
    struct ImageData: Decodable {
        let previewURL: String
        let webformatURL: String
    }
}
