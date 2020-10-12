//
//  ViewController.swift
//  TFS Chat
//
//  Created by dmitry on 11.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var jobTitleLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    var imagePicker = UIImagePickerController()
    var avatarUpdaterDelegate: AvatarUpdaterDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //printSaveButtonFrame(#function) view is not initialized yet, saveButton is nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        printStateInfo(#function)
        printSaveButtonFrame(#function)
        saveButton.layer.cornerRadius = 14;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printStateInfo(#function)
        adjustViewForCurrentTheme()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "From Photo Library", style: .default, handler: { [weak self] _ in
            self?.selectFromLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { [weak self] _ in
            self?.selectFromCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func selectFromCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Camera is not available")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func selectFromLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showAlert(title: "Photo Library is not available")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileLogoView.setImage(image)
            avatarUpdaterDelegate?.updateAvatar(to: image)
            DispatchQueue.global(qos: .utility).async {
                FileUtil.saveAvatarImage(image: image)
            }
        }
    }
    
}

extension ProfileViewController: Themable {
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.instance.currentTheme
        view.backgroundColor = theme.conversationViewBackgroundColor
        saveButton.layer.backgroundColor = theme.navigationBarColor.cgColor
        nameLabel.textColor = theme.navigationBarTextColor
        jobTitleLabel.textColor = theme.navigationBarTextColor
        cityLabel.textColor = theme.navigationBarTextColor
        navigationController?.navigationBar.barTintColor = theme.navigationBarColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
    }
}

protocol AvatarUpdaterDelegate {
    func updateAvatar(to image: UIImage)
}

extension ProfileViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printStateInfo(#function)
        
        /*
         Storyboard XML contains coordinates of elements in coordinate system of a device
         which selected in "View as" section.
         After initialization of view, Autolayout mechanism performs
         and adjusts coordinates for an actual device.
         */
        printSaveButtonFrame(#function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printStateInfo(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printStateInfo(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printStateInfo(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printStateInfo(#function)
    }
    
    private func printStateInfo(_ methodName: String) {
        LoggingUtil.debugPrint("Method \(methodName) of ViewController was called")
    }
    
    private func printSaveButtonFrame(_ methodName: String) {
        LoggingUtil.debugPrint("'Save button' frame in \(methodName)) is \(saveButton.frame)")
    }
}

