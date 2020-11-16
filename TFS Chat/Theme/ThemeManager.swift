//
//  ThemeManager.swift
//  TFS Chat
//
//  Created by dmitry on 07.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ThemeManager: ThemesPickerDelegate {
    
    static let instance = ThemeManager()
    var currentTheme: ColorTheme
    
    private init() {
        let storedTheme = UserDefaults.standard.integer(forKey: "SelectedTheme")
        currentTheme = ColorTheme(rawValue: storedTheme) ?? .classic
    }
    
    func applyTheme(_ theme: ColorTheme) {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.set(theme.rawValue, forKey: "SelectedTheme")
            UserDefaults.standard.synchronize()
        }
        currentTheme = theme
    }
    
}

protocol Themable {
    func adjustViewForCurrentTheme()
}
