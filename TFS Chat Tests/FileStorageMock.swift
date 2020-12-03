//
//  ApiServiceMock.swift
//  TFS Chat Tests
//
//  Created by dmitry on 03.12.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

@testable import TFS_Chat
import Foundation
import UIKit

class FileStorageMock: FileStorageProtocol {
    var avatarFile = "avatarFile"
    var profileNameFile = "profileNameFile"
    var profileInfoFile = "profileInfoFile"
    
    var fileName: String!
    var callsCount = 0
    var savedData: String!
    
    func saveString(_ input: String, fileName: String) -> Bool {
        callsCount += 1
        self.fileName = fileName
        self.savedData = input
        return true
    }
    
}

extension FileStorageMock {
    
    func saveImage(image: UIImage, fileName: String) -> Bool {
        return true
    }
    
    func loadImage(fileName: String) -> UIImage? {
        return UIImage()
    }
    
    func loadString(fileName: String) -> String? {
        return String()
    }
}
