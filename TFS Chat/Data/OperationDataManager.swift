//
//  OperationDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct OperationDataManager: DataManager {
    
    static let instance = OperationDataManager()
    
    let queue: OperationQueue
    
    private init() {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
    }
    
    func saveAvatar(image: UIImage, updateAction: @escaping (UIImage) -> Void, completion: @escaping () -> Void, failure: @escaping  () -> Void) {
        let operation = SaveImageOperation(dataToSave: image)
        operation.completionBlock = {
            if operation.success {
                OperationQueue.main.addOperation {
                    updateAction(image)
                }
                completion()
            } else {
                failure()
            }
        }
        queue.addOperation(operation)
    }
    
    func saveName(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileUtil.profileNameFile, completion: completion, failure: failure)
    }
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileUtil.profileInfoFile, completion: completion, failure: failure)
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
            if let image = FileUtil.loadAvatarImage() {
                OperationQueue.main.addOperation {
                    completion(image)
                }
            } else { failure() }
        }
    }
    
    func loadProfileName(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = FileUtil.loadString(fileName: FileUtil.profileNameFile) {
                OperationQueue.main.addOperation {
                    completion(data)
                }
            } else { failure() }
        }
    }
    
    func loadProfileInfo(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.addOperation {
            if let data = FileUtil.loadString(fileName: FileUtil.profileInfoFile) {
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
        success = FileUtil.saveString(dataToSave, fileName: fileName)
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
        success = FileUtil.saveAvatarImage(image: dataToSave)
    }
    
}

