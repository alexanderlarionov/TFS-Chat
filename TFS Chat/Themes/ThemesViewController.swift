//
//  ThemesViewController.swift
//  TFS Chat
//
//  Created by dmitry on 06.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    var themesDelegate: ThemesPickerDelegate!
    static var currentTheme = Theme.classic
    
    @IBOutlet var classicButton: UIButton!
    @IBOutlet var dayButton: UIButton!
    @IBOutlet var nightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cornerRadius = CGFloat(14)
        classicButton.layer.cornerRadius = cornerRadius
        dayButton.layer.cornerRadius = cornerRadius
        nightButton.layer.cornerRadius = cornerRadius
        let borderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        classicButton.layer.borderColor = borderColor
        dayButton.layer.borderColor = borderColor
        nightButton.layer.borderColor = borderColor
        adjustView(for: ThemesViewController.currentTheme)
    }

    @IBAction func classicButtonPressed(_ sender: UIButton) {
        handleThemeSelection(.classic)
    }
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        handleThemeSelection(.day)
    }
    
    @IBAction func nightButtonPressed(_ sender: UIButton) {
        handleThemeSelection(.night)
    }
    
    private func handleThemeSelection(_ theme: Theme) {
        themesDelegate.changeTheme(to: theme)
        ThemesViewController.currentTheme = theme
        adjustView(for: theme)
    }
    
    private func adjustView(for theme: Theme) {
        switch theme {
        case .classic:
            view.backgroundColor = UIColor(red: 0.07, green: 0.55, blue: 0.49, alpha: 1.00)
            highlightButton(classicButton)
        case .day:
            view.backgroundColor = UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1)
            highlightButton(dayButton)
        case .night:
            view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
            highlightButton(nightButton)
        }
    }
    
    private func highlightButton(_ button: UIButton) {
        classicButton.layer.borderWidth = 0
        dayButton.layer.borderWidth = 0
        nightButton.layer.borderWidth = 0
        button.layer.borderWidth = 3
    }
}

protocol ThemesPickerDelegate {
    func changeTheme(to theme: Theme)
}

enum Theme {
    case classic, night, day
}
