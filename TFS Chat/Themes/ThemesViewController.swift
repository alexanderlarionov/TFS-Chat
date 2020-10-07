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
    
    @IBOutlet var classicButtonView: UIView!
    @IBOutlet var dayButtonView: UIView!
    @IBOutlet var nightButtonView: UIView!
    
    @IBOutlet var classicLeftLabel: UILabel!
    @IBOutlet var classicRightLabel: UILabel!
    @IBOutlet var dayLeftLabel: UILabel!
    @IBOutlet var dayRightLabel: UILabel!
    @IBOutlet var nightLeftLabel: UILabel!
    @IBOutlet var nightRightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonBorderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        for buttonView in [classicButtonView, dayButtonView, nightButtonView] {
            buttonView?.layer.cornerRadius = 14
            buttonView?.layer.borderColor = buttonBorderColor
        }
        for label in [classicLeftLabel, classicRightLabel, dayLeftLabel, dayRightLabel, nightLeftLabel, nightRightLabel] {
            label?.layer.cornerRadius = 7
        }
        adjustView(for: ThemesViewController.currentTheme)
    }
    
    @IBAction func classicButtonPressed(_ sender: Any) {
        handleThemeSelection(.classic)
    }
    
    @IBAction func dayButtonPressed(_ sender: Any) {
        handleThemeSelection(.day)
    }
    
    @IBAction func nightButtonPressed(_ sender: Any) {
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
            highlightButton(classicButtonView)
        case .day:
            view.backgroundColor = UIColor(red: 0.098, green: 0.21, blue: 0.379, alpha: 1)
            highlightButton(dayButtonView)
        case .night:
            view.backgroundColor = UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1)
            highlightButton(nightButtonView)
        }
    }
    
    private func highlightButton(_ button: UIView) {
        classicButtonView.layer.borderWidth = 0
        dayButtonView.layer.borderWidth = 0
        nightButtonView.layer.borderWidth = 0
        button.layer.borderWidth = 3
    }
}

protocol ThemesPickerDelegate {
    func changeTheme(to theme: Theme)
}

enum Theme {
    case classic, night, day
}
