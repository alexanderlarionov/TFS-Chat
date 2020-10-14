//
//  GCDDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct GCDDataManager {
    
    let queue: DispatchQueue
    let group: DispatchGroup
    
    init() {
        queue = DispatchQueue(label: "com.akatev.TFS-Chat", attributes: .concurrent)
        group = DispatchGroup()
    }
    
    func saveAvatar(image: UIImage, updateAction: @escaping (UIImage) -> Void, completion: @escaping () -> Void, failure: @escaping  () -> Void) {
        group.enter()
        queue.async {
            if FileUtil.saveAvatarImage(image: image) {
                DispatchQueue.main.async {
                    updateAction(image)
                }
                completion()
            } else {
                failure()
            }
            group.leave()
        }
    }
    
    func saveName(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileUtil.profileNameFile, completion: completion, failure: failure)
    }
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        saveString(value: value, fileName: FileUtil.profileInfoFile, completion: completion, failure: failure)
    }
    
    func completeSave(completion: @escaping () -> Void) {
        group.notify(queue: queue) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func saveString(value: String, fileName: String, completion: @escaping () -> Void, failure: @escaping () -> Void) {
        group.enter()
        queue.async {
            if FileUtil.saveString(value, fileName: fileName) {
                completion()
            } else {
                failure()
            }
            group.leave()
        }
    }
}
