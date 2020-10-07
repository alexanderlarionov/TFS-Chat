//
//  ThemeManager.swift
//  TFS Chat
//
//  Created by dmitry on 07.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

struct ThemeManager: ThemesPickerDelegate {
    
    static func currentTheme() -> ColorTheme {
        let storedTheme = UserDefaults.standard.integer(forKey: "SelectedTheme")
        return ColorTheme(rawValue: storedTheme) ?? .classic
    }
    
    func applyTheme(_ theme: ColorTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "SelectedTheme")
        UserDefaults.standard.synchronize()
    }
    
}

protocol Themable {
    func adjustViewForCurrentTheme()
}

