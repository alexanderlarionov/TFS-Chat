//
//  FileManager.swift
//  TFS Chat
//
//  Created by dmitry on 12.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

protocol FileStorageProtocol {
    
    static func saveImage(image: UIImage, fileName: String) -> Bool
    
    static func loadImage(fileName: String) -> UIImage?
    
    static func saveString(_ input: String, fileName: String) -> Bool
    
    static func loadString(fileName: String) -> String?
}

class FileStorage: FileStorageProtocol {
    
    static func saveImage(image: UIImage, fileName: String) -> Bool {
        do {
            try image.jpegData(compressionQuality: 1)?.write(to: getDocumentsDirectory().appendingPathComponent(avatarFile))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func loadImage(fileName: String) -> UIImage? {
        return UIImage(contentsOfFile: URL(fileURLWithPath: getDocumentsDirectory().absoluteString).appendingPathComponent(avatarFile).path)
    }
    
    static func saveString(_ input: String, fileName: String) -> Bool {
        do {
            try input.write(to: getDocumentsDirectory().appendingPathComponent(fileName), atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func loadString(fileName: String) -> String? {
        do {
            return try String(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName), encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

extension FileStorage {
    static let avatarFile = "avatar.jpeg"
    static let profileNameFile = "profileName.txt"
    static let profileInfoFile = "profileInfo.txt"
}
