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
    
    /* Uncomment for error handling check
    enum MyError: Error {
        case runtimeError(String)
    }
    */
    
    static func saveAvatarImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) else { return false }
        do {
            //let randomInt = Int.random(in: 1..<3)
            //if randomInt % 2 == 0 { throw MyError.runtimeError("avatar not saved") }
            try data.write(to: getDocumentsDirectory().appendingPathComponent(avatarFile))
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    static func loadAvatarImage() -> UIImage? {
        return UIImage(contentsOfFile: URL(fileURLWithPath: getDocumentsDirectory().absoluteString).appendingPathComponent(avatarFile).path)
    }
    
    static func saveString(_ input: String, fileName: String) -> Bool {
        do {
            //let randomInt = Int.random(in: 1..<3)
            //if randomInt % 2 == 0 { throw MyError.runtimeError("info not saved") }
            try input.write(to: getDocumentsDirectory().appendingPathComponent(fileName), atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    static func loadString(fileName: String) -> String? {
        do {
            return try String(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName), encoding: .utf8)
        }
        catch {
            print(error)
            return nil
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
