//
//  ImageParser.swift
//  TFS Chat
//
//  Created by dmitry on 19.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import UIKit

class ImageParser: ParserProtocol {
    
    typealias Model = UIImage
    
    func parse(data: Data) -> UIImage? {
        if let image = UIImage(data: data) {
            return image
        } else {
            print("Error trying to convert data to image")
            return nil
        }
    }
}
