//
//  OperationDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class OperationDataManager: FileStorageServiceProtocol {
    
    let fileStorage: FileStorageProtocol
    let queue: OperationQueue
    
    init(fileStorage: FileStorageProtocol) {
        self.fileStorage = fileStorage
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
    }
    
    func saveAvatar(image: UIImage, completion: @escaping (UIImage) -> Void, failure: @escaping  () -> Void) {
        let operation = SaveImageOperation(fileStorage: fileStorage, dataToSave: image)
        operation.completionBlock = {
            if operation.success {
                OperationQueue.main.addOperation {
                    completion(image)
                }
            } else {
                failure()
            }
        }
        queue.addOperation(operation)
    }
    
    func saveName(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: fileStorage.profileNameFile, completion: completion, failure: failure)
    }
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: fileStorage.profileInfoFile, completion: completion, failure: failure)
    }
    
    private func saveString(value: String, fileName: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        let operation = SaveTextOperation(fileStorage: fileStorage, dataToSave: value, fileName: fileName)
        operation.completionBlock = {
            if operation.success {
                completion()
            } else {
                failure()
            }
        }
        queue.addOperation(operation)
    }
    
    func completeBatchSave(completion: @escaping () -> Void) {
        OperationQueue.main.addOperation {
            completion() //TODO add dependency
        }
    }
    
    func loadAvatar(completion: @escaping (UIImage) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let image = self.fileStorage.loadImage(fileName: self.fileStorage.avatarFile) {
                OperationQueue.main.addOperation {
                    completion(image)
                }
            } else { failure() }
        }
    }
    
    func loadProfileName(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = self.fileStorage.loadString(fileName: self.fileStorage.profileNameFile) {
                OperationQueue.main.addOperation {
                    completion(data)
                }
            } else { failure() }
        }
    }
    
    func loadProfileInfo(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = self.fileStorage.loadString(fileName: self.fileStorage.profileInfoFile) {
                OperationQueue.main.addOperation {
                    completion(data)
                }
            } else { failure() }
        }
    }
}

class SaveTextOperation: Operation {
    var dataToSave: String
    var fileName: String
    var success = false
    let fileStorage: FileStorageProtocol
    
    init(fileStorage: FileStorageProtocol, dataToSave: String, fileName: String) {
        self.dataToSave = dataToSave
        self.fileName = fileName
        self.fileStorage = fileStorage
        super.init()
    }
    
    override func main() {
        success = fileStorage.saveString(dataToSave, fileName: fileName)
    }
    
}

class SaveImageOperation: Operation {
    var dataToSave: UIImage
    var success = false
    let fileStorage: FileStorageProtocol
    
    init(fileStorage: FileStorageProtocol, dataToSave: UIImage) {
        self.dataToSave = dataToSave
        self.fileStorage = fileStorage
        super.init()
    }
    
    override func main() {
        success = fileStorage.saveImage(image: dataToSave, fileName: fileStorage.avatarFile)
    }
    
}
