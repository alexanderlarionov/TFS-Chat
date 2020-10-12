//
//  FileManager.swift
//  TFS Chat
//
//  Created by dmitry on 12.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class FileUtil {
    
    static func saveAvatarImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        do {
            try data.write(to: getDocumentsDirectory().appendingPathComponent("avatar.jpeg"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadAvatarImage() -> UIImage? {
        return UIImage(contentsOfFile: URL(fileURLWithPath: getDocumentsDirectory().absoluteString).appendingPathComponent("avatar.jpeg").path)
    }
    
    static func saveString(_ input: String, fileName: String) {
        do {
            try input.write(to: getDocumentsDirectory().appendingPathComponent(fileName), atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadString(fileName: String) -> String? {
        do {
            return try String(contentsOf: getDocumentsDirectory().appendingPathComponent(fileName), encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
