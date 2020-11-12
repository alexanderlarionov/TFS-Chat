//
//  OperationDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct OperationDataManager: FileStorageServiceProtocol {
    
    static let instance = OperationDataManager()
    
    let queue: OperationQueue
    
    private init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
    }
    
    func saveAvatar(image: UIImage, completion: @escaping (UIImage) -> Void, failure: @escaping  () -> Void) {
        let operation = SaveImageOperation(dataToSave: image)
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
        saveString(value: value, fileName: FileStorage.profileNameFile, completion: completion, failure: failure)
    }
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileStorage.profileInfoFile, completion: completion, failure: failure)
    }
    
    private func saveString(value: String, fileName: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        let operation = SaveTextOperation(dataToSave: value, fileName: fileName)
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
            if let image = FileStorage.loadImage(fileName: FileStorage.avatarFile) {
                OperationQueue.main.addOperation {
                    completion(image)
                }
            } else { failure() }
        }
    }
    
    func loadProfileName(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = FileStorage.loadString(fileName: FileStorage.profileNameFile) {
                OperationQueue.main.addOperation {
                    completion(data)
                }
            } else { failure() }
        }
    }
    
    func loadProfileInfo(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = FileStorage.loadString(fileName: FileStorage.profileInfoFile) {
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
    
    init(dataToSave: String, fileName: String) {
        self.dataToSave = dataToSave
        self.fileName = fileName
        super.init()
    }
    
    override func main() {
        success = FileStorage.saveString(dataToSave, fileName: fileName)
    }
    
}

class SaveImageOperation: Operation {
    var dataToSave: UIImage
    var success = false
    
    init(dataToSave: UIImage) {
        self.dataToSave = dataToSave
        super.init()
    }
    
    override func main() {
        success = FileStorage.saveImage(image: dataToSave, fileName: FileStorage.avatarFile)
    }
    
}
