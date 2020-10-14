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
    var nameBeforeChange: String?
    var infoBeforeChange: String?
    var avatarBeforeChange: UIImage?

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
        setSaveButtonEnable(false)
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        if let name = FileUtil.loadString(fileName: FileUtil.profileNameFile) {
            nameTextField.text = name
        }
        if let info = FileUtil.loadString(fileName: FileUtil.profileInfoFile) {
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
        setEditButtonVisible(false)
        
        nameBeforeChange = nameTextField.text
        infoBeforeChange = infoTextView.text
        avatarBeforeChange = profileLogoView.profileImage.image
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        nameTextField.isUserInteractionEnabled = false
        nameTextField.layer.borderWidth = 0
        infoTextView.layer.borderWidth = 0
        infoTextView.isEditable = false
        editAvatarButton.isHidden = true
        setSaveButtonEnable(false)
        activityIndicator.startAnimating()
        saveData()
    }
    
    private func saveData() {
        let dataManager = GCDDataManager()
        
        var avatarSaved = true
        var nameSaved = true
        var infoSaved = true
       
        if profileLogoView.profileImage.image != avatarBeforeChange {
            guard let avatar = profileLogoView.profileImage.image else { return }
            dataManager.saveAvatar(image: avatar,
                                   updateAction: { avatar in
                                    self.avatarUpdaterDelegate?.updateAvatar(to: avatar)
                                   },
                                   completion: {
                                    self.avatarBeforeChange = avatar
                                   },
                                   failure: {
                                    avatarSaved = false
                                   })
        }
       
        if nameTextField.text != nameBeforeChange {
            guard let name = nameTextField.text else { return }
            dataManager.saveName(value: name,
                                 completion: {
                                  self.nameBeforeChange = name
                                 },
                                 failure: {
                                    nameSaved = false
                                 })
        }
        
        if infoTextView.text != infoBeforeChange {
            guard let info = infoTextView.text else { return }
            dataManager.saveInfo(value: info,
                                 completion: {
                                  self.infoBeforeChange = info
                                 },
                                 failure: {
                                    infoSaved = false
                                 })
        }

        dataManager.completeSave(completion: { self.handleSavingResult(avatarSaved: avatarSaved, nameSaved: nameSaved, infoSaved: infoSaved) })
    }
    
    
    func handleSavingResult(avatarSaved: Bool, nameSaved: Bool, infoSaved: Bool) {
        self.activityIndicator.stopAnimating()
        self.setSaveButtonEnable(false)
        self.setEditButtonVisible(true)
        
        if avatarSaved && nameSaved && infoSaved {
            self.showOkAlert(title: "Data succesfully saved")
        } else {
            var errorsCollector = [String]()
            if !avatarSaved { errorsCollector.append("Avatar") }
            if !nameSaved { errorsCollector.append("Name") }
            if !infoSaved { errorsCollector.append("Info") }
            self.showErrorAlert(title: "Error: \(errorsCollector.joined(separator: ", ")) not saved")
        }
    }
    
    func showErrorAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.infoTextView.text = self.infoBeforeChange
            self.profileLogoView.profileImage.image = self.avatarBeforeChange
            self.nameTextField.text = self.nameBeforeChange }
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) {_ in
            self.activityIndicator.startAnimating()
            self.saveData()
        }
        ac.addAction(okAction)
        ac.addAction(tryAgainAction)
        self.present(ac, animated: true)
    }
    
    func showOkAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func setSaveButtonEnable(_ state: Bool) {
        if state {
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
        } else {
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
        }
    }
    
    func setEditButtonVisible(_ state: Bool) {
        if state {
            editProfileButton.isEnabled = true
            editProfileButton.tintColor = nil
        } else {
            editProfileButton.isEnabled = false
            editProfileButton.tintColor = .clear
        }
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileLogoView.setImage(image)
            setSaveButtonEnable(true)
        }
    }
    
    func selectFromCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showOkAlert(title: "Camera is not available")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func selectFromLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showOkAlert(title: "Photo Library is not available")
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        setSaveButtonEnable(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.frame.origin.y = -200
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.frame.origin.y = 0
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setSaveButtonEnable(true)
    }
    
    private func setNameFieldPadding(_ padding: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        nameTextField.rightView = paddingView
        nameTextField.rightViewMode = .always
    }
    
}


