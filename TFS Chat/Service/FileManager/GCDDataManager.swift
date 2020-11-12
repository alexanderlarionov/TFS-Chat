//
//  GCDDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct GCDDataManager: FileStorageServiceProtocol {
    
    let fileStorage: FileStorageProtocol
    let queue: DispatchQueue
    let group: DispatchGroup
    
    init(fileStorage: FileStorageProtocol) {
        queue = DispatchQueue(label: "com.akatev.TFS-Chat", attributes: .concurrent)
        group = DispatchGroup()
        self.fileStorage = fileStorage
    }
    
    func saveAvatar(image: UIImage, completion: @escaping (UIImage) -> Void, failure: @escaping () -> Void) {
        group.enter()
        queue.async {
            if fileStorage.saveImage(image: image, fileName: FileStorage.avatarFile) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                failure()
            }
            group.leave()
        }
    }
    
    func saveName(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileStorage.profileNameFile, completion: completion, failure: failure)
    }
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileStorage.profileInfoFile, completion: completion, failure: failure)
    }
    
    func completeBatchSave(completion: @escaping () -> Void) {
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func loadAvatar(completion: @escaping (UIImage) -> Void, failure: @escaping () -> Void) {
        queue.async {
            if let image = fileStorage.loadImage(fileName: FileStorage.avatarFile) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    failure()                }
            }
        }
    }
    
    func loadProfileName(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        loadString(fileName: FileStorage.profileNameFile, completion: completion, failure: failure)
    }
    
    func loadProfileInfo(completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        loadString(fileName: FileStorage.profileInfoFile, completion: completion, failure: failure)
    }
    
    private func loadString(fileName: String, completion: @escaping (String) -> Void, failure: @escaping () -> Void) {
        queue.async {
            if let image = fileStorage.loadString(fileName: fileName) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
    
    private func saveString(value: String, fileName: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        group.enter()
        queue.async {
            if fileStorage.saveString(value, fileName: fileName) {
                completion()
            } else {
                failure()
            }
            group.leave()
        }
    }
}
