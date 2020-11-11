//
//  FileManager.swift
//  TFS Chat
//
//  Created by dmitry on 12.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct FileUtil {
    
    static let avatarFile = "avatar.jpeg"
    static let profileNameFile = "profileName.txt"
    static let profileInfoFile = "profileInfo.txt"
    
    static func saveAvatarImage(image: UIImage) -> Bool {
        do {
            try image.jpegData(compressionQuality: 1)?.write(to: getDocumentsDirectory().appendingPathComponent(avatarFile))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func loadAvatarImage() -> UIImage? {
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
