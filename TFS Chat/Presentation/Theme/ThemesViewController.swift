//
//  ThemesViewController.swift
//  TFS Chat
//
//  Created by dmitry on 06.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    weak var themesPickerDelegate: ThemesPickerDelegate?
    var applyThemeBlock: ((ColorTheme) -> Void)?
    
    @IBOutlet var classicButtonView: UIView!
    @IBOutlet var dayButtonView: UIView!
    @IBOutlet var nightButtonView: UIView!
    
    @IBOutlet var classicLeftLabel: UILabel!
    @IBOutlet var classicRightLabel: UILabel!
    @IBOutlet var dayLeftLabel: UILabel!
    @IBOutlet var dayRightLabel: UILabel!
    @IBOutlet var nightLeftLabel: UILabel!
    @IBOutlet var nightRightLabel: UILabel!
    
    let animationLayer = CAEmitterLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        let buttonBorderColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1).cgColor
        for buttonView in [classicButtonView, dayButtonView, nightButtonView] {
            buttonView?.layer.cornerRadius = 14
            buttonView?.layer.borderColor = buttonBorderColor
        }
        for label in [classicLeftLabel, classicRightLabel, dayLeftLabel, dayRightLabel, nightLeftLabel, nightRightLabel] {
            label?.layer.cornerRadius = 7
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    @IBAction func longPressedAction(_ sender: UILongPressGestureRecognizer) {
        showTinkoffAnimation(sender: sender, layer: animationLayer)
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
    
    private func handleThemeSelection(_ theme: ColorTheme) {
        //themesPickerDelegate?.applyTheme(_: theme)
        applyThemeBlock?(theme)
        adjustViewForCurrentTheme()
    }
    
}

protocol ThemesPickerDelegate: class {
    func applyTheme(_: ColorTheme)
}

extension ThemesViewController: Themable {
    
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.instance.currentTheme
        view.backgroundColor = theme.themesViewControllerBackgroundColor
        switch theme {
        case .classic:
            highlightButton(classicButtonView)
        case .day:
            highlightButton(dayButtonView)
        case .night:
            highlightButton(nightButtonView)
        }
        //TODO how to adjust navbar color?
    }
    
    private func highlightButton(_ button: UIView) {
        classicButtonView.layer.borderWidth = 0
        dayButtonView.layer.borderWidth = 0
        nightButtonView.layer.borderWidth = 0
        button.layer.borderWidth = 3
    }
}
