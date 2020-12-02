//
//  FileManager.swift
//  TFS Chat
//
//  Created by dmitry on 12.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

protocol FileStorageProtocol {
    
    static var avatarFile: String { get }
    static var profileNameFile: String { get }
    static var profileInfoFile: String { get }
    
    func saveImage(image: UIImage, fileName: String) -> Bool
    
    func loadImage(fileName: String) -> UIImage?
    
    func saveString(_ input: String, fileName: String) -> Bool
    
    func loadString(fileName: String) -> String?
}

class FileStorage: FileStorageProtocol {
    
    static var avatarFile = "avatar.jpeg"
    static var profileNameFile = "profileName.txt"
    static var profileInfoFile = "profileInfo.txt"
    
    func saveImage(image: UIImage, fileName: String) -> Bool {
        do {
            try image.jpegData(compressionQuality: 1)?.write(to: getDocumentsDirectory().appendingPathComponent(fileName))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        return UIImage(contentsOfFile: URL(fileURLWithPath: getDocumentsDirectory().absoluteString).appendingPathComponent(fileName).path)
    }
    
    func saveString(_ input: String, fileName: String) -> Bool {
        do {
            try input.write(to: getDocumentsDirectory().appendingPathComponent(fileName), atomically: true, encoding: String.Encoding.utf8)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func loadString(fileName: String) -> String? {
        do {
            return try String(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName), encoding: .utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
