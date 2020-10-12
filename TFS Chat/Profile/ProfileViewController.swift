//
//  ViewController.swift
//  TFS Chat
//
//  Created by dmitry on 11.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var editProfileButton: UIBarButtonItem!
    @IBOutlet var editAvatarButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var infoTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    var avatarUpdaterDelegate: AvatarUpdaterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        infoTextView.delegate = self
        nameTextField.delegate = self
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.cornerRadius = 5
        setNameFieldPadding(10)
        infoTextView.layer.borderColor = UIColor.lightGray.cgColor
        infoTextView.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 14;
        disableButton(saveButton)
        if let name = FileUtil.loadString(fileName: "profileName.txt") {
            nameTextField.text = name
        }
        if let info = FileUtil.loadString(fileName: "profileInfo.txt") {
            infoTextView.text = info
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    @IBAction func editAvatarButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        nameTextField.isUserInteractionEnabled = true
        nameTextField.layer.borderWidth = 1.0
        infoTextView.isEditable = true
        infoTextView.layer.borderWidth = 1.0
        editAvatarButton.isHidden = false
        editProfileButton.isEnabled = false
        editProfileButton.tintColor = UIColor.clear
        enableButton(saveButton)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        nameTextField.layer.borderWidth = 0
        infoTextView.layer.borderWidth = 0
        nameTextField.isUserInteractionEnabled = false
        infoTextView.isEditable = false
        editAvatarButton.isHidden = true
        disableButton(saveButton)
        
        activityIndicator.startAnimating()
        
        let queue = DispatchQueue(label: "com.akatev.TFS-Chat", attributes: .concurrent)
        let group = DispatchGroup()
        
        group.enter()
        let avatar = profileLogoView.profileImage.image
        if let avatar = avatar {
            queue.async {
                FileUtil.saveAvatarImage(image: avatar)
                group.leave()
            }
        }
        
        group.enter()
        if let name = nameTextField.text {
            queue.async {
                FileUtil.saveString(name, fileName: "profileName.txt")
                group.leave()
            }
        }
        
        group.enter()
        if let info = infoTextView.text {
            queue.async {
                FileUtil.saveString(info, fileName: "profileInfo.txt")
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: "Data succesfully saved")
                self?.activityIndicator.stopAnimating()
                self?.editProfileButton.isEnabled = true
                self?.editProfileButton.tintColor = nil
                if let avatar = avatar {
                    self?.avatarUpdaterDelegate?.updateAvatar(to: avatar)
                }
            }
        }
        
    }
    
    func showAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func disableButton(_ button: UIButton) {
        button.isEnabled = false
        button.alpha = 0.5
    }
    
    func enableButton(_ button: UIButton) {
        button.isEnabled = true
        button.alpha = 1.0
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileLogoView.setImage(image)
        }
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
}

extension ProfileViewController: Themable {
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.instance.currentTheme
        view.backgroundColor = theme.conversationViewBackgroundColor
        saveButton.layer.backgroundColor = theme.navigationBarColor.cgColor
        nameTextField.textColor = theme.navigationBarTextColor
        infoTextView.textColor = theme.navigationBarTextColor
        infoTextView.backgroundColor = view.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.navigationBarColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
    }
}

protocol AvatarUpdaterDelegate {
    func updateAvatar(to image: UIImage)
}

extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.frame.origin.y = -200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.frame.origin.y = 0
    }
    
    private func setNameFieldPadding(_ padding: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        nameTextField.rightView = paddingView
        nameTextField.rightViewMode = .always
    }
    
}


