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
        guard let data = image.jpegData(compressionQuality: 1) else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else { return }
        do {
            try data.write(to: directory.appendingPathComponent("avatar.jpeg"))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadAvatarImage() -> UIImage? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else { return nil}
        
        return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent("avatar.jpeg").path)
    }
    
}
