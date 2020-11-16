//
//  DataManager.swift
//  TFS Chat
//
//  Created by dmitry on 14.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

protocol DataManager {
    
    func saveAvatar(image: UIImage, completion: @escaping (UIImage) -> Void, failure: @escaping  () -> Void)
    
    func saveName(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void)
    
    func saveInfo(value: String, completion: @escaping () -> Void, failure: @escaping () -> Void)
    
    func completeBatchSave(completion: @escaping () -> Void)
    
    func loadAvatar(completion: @escaping (UIImage) -> Void, failure: @escaping () -> Void)
    
    func loadProfileName(completion: @escaping (String) -> Void, failure: @escaping () -> Void)
    
    func loadProfileInfo(completion: @escaping (String) -> Void, failure: @escaping () -> Void)
    
}
