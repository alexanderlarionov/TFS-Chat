//
//  GCDDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct GCDDataManager: FileStorageServiceProtocol {
    
    static let instance = GCDDataManager()
    
    let queue: DispatchQueue
    let group: DispatchGroup
    
    private init() {
        queue = DispatchQueue(label: "com.akatev.TFS-Chat", attributes: .concurrent)
        group = DispatchGroup()
    }
    
    func saveAvatar(image: UIImage, completion: @escaping (UIImage) -> Void, failure: @escaping () -> Void) {
        group.enter()
        queue.async {
            if FileStorage.saveImage(image: image, fileName: FileStorage.avatarFile) {
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
            if let image = FileStorage.loadImage(fileName: FileStorage.avatarFile) {
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
            if let image = FileStorage.loadString(fileName: fileName) {
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
            if FileStorage.saveString(value, fileName: fileName) {
                completion()
            } else {
                failure()
            }
            group.leave()
        }
    }
}
