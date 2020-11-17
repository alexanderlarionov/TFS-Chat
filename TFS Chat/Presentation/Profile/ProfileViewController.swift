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
    @IBOutlet var saveGCDButton: UIButton!
    @IBOutlet var saveOperationsButton: UIButton!
    @IBOutlet var editProfileButton: UIBarButtonItem!
    @IBOutlet var editAvatarButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var infoTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    weak var avatarUpdaterDelegate: AvatarUpdaterDelegate?
    lazy var imagePicker = UIImagePickerController()
    var nameBeforeChange: String?
    var infoBeforeChange: String?
    var avatarBeforeChange: UIImage?
    
    var gcdDataManager: FileStorageServiceProtocol!
    var operationDataManager: FileStorageServiceProtocol!
    var presentationAssembly: PresentationAssemblyProtocol!
    
    func injectDependcies(presentationAssembly: PresentationAssembly, gcdDataManager: FileStorageServiceProtocol, operationDataManager: FileStorageServiceProtocol) {
        self.gcdDataManager = gcdDataManager
        self.operationDataManager = operationDataManager
        self.presentationAssembly = presentationAssembly
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        infoTextView.delegate = self
        nameTextField.delegate = self
        setupTextFields()
        setupButtons()
        activityIndicator.startAnimating()
        loadProfileName()
        loadProfileInfo()
        profileLogoView.finishViewLoading(dataManager: gcdDataManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    @IBAction func editAvatarButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "From Photo Library", style: .default, handler: { _ in
            self.selectFromLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { _ in
            self.selectFromCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "From Pixabay", style: .default, handler: { _ in
            self.loadFromPixabay()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func loadFromPixabay() {
        let controller = presentationAssembly.imageCollectionController()
        self.present(controller, animated: true)
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
    
    @IBAction func saveGCDButtonPressed(_ sender: UIButton) {
        handleSaveButtonPressed()
        saveData(dataManager: gcdDataManager)
    }
    
    @IBAction func saveOperationsButtonPressed(_ sender: UIButton) {
        handleSaveButtonPressed()
        saveData(dataManager: operationDataManager)
    }
    
    func saveData(dataManager: FileStorageServiceProtocol) {
        var avatarSaved = true
        var nameSaved = true
        var infoSaved = true
        
        if profileLogoView.profileImage.image != avatarBeforeChange {
            if let avatar = profileLogoView.profileImage.image {
                dataManager.saveAvatar(image: avatar,
                                       completion: { avatar in
                                        self.avatarUpdaterDelegate?.updateAvatar(to: avatar)
                                        self.avatarBeforeChange = avatar
                                       },
                                       failure: {
                                        avatarSaved = false
                                       })
            }
        }
        
        if nameTextField.text != nameBeforeChange {
            if let name = nameTextField.text {
                dataManager.saveName(value: name,
                                     completion: {
                                        self.nameBeforeChange = name
                                     },
                                     failure: {
                                        nameSaved = false
                                     })
            }
        }
        
        if infoTextView.text != infoBeforeChange {
            if let info = infoTextView.text {
                dataManager.saveInfo(value: info,
                                     completion: {
                                        self.infoBeforeChange = info
                                     },
                                     failure: {
                                        infoSaved = false
                                     })
            }
        }
        
        dataManager.completeBatchSave(completion: { self.handleSavingResult(avatarSaved: avatarSaved, nameSaved: nameSaved, infoSaved: infoSaved, dataManager: dataManager) })
    }
    
    func handleSavingResult(avatarSaved: Bool, nameSaved: Bool, infoSaved: Bool, dataManager: FileStorageServiceProtocol) {
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
            self.showErrorAlert(title: "Error: \(errorsCollector.joined(separator: ", ")) not saved", dataManager: dataManager)
        }
    }
    
    func showErrorAlert(title: String, dataManager: FileStorageServiceProtocol) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.infoTextView.text = self.infoBeforeChange
            self.profileLogoView.profileImage.image = self.avatarBeforeChange
            self.nameTextField.text = self.nameBeforeChange }
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) {_ in
            self.activityIndicator.startAnimating()
            self.saveData(dataManager: dataManager)
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
            saveGCDButton.isEnabled = true
            saveGCDButton.alpha = 1.0
            saveOperationsButton.isEnabled = true
            saveOperationsButton.alpha = 1.0
        } else {
            saveGCDButton.isEnabled = false
            saveGCDButton.alpha = 0.5
            saveOperationsButton.isEnabled = false
            saveOperationsButton.alpha = 0.5
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
    
    func handleSaveButtonPressed() {
        nameTextField.isUserInteractionEnabled = false
        nameTextField.layer.borderWidth = 0
        infoTextView.layer.borderWidth = 0
        infoTextView.isEditable = false
        editAvatarButton.isHidden = true
        setSaveButtonEnable(false)
        activityIndicator.startAnimating()
    }
    
    func setupTextFields() {
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.cornerRadius = 5
        setNameFieldPadding(10)
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.isHidden = true
        
        infoTextView.layer.borderColor = UIColor.lightGray.cgColor
        infoTextView.layer.cornerRadius = 5
        infoTextView.isHidden = true
    }
    
    func setupButtons() {
        saveGCDButton.layer.cornerRadius = 14
        saveOperationsButton.layer.cornerRadius = 14
        setSaveButtonEnable(false)
    }
    
    func loadProfileName() {
        gcdDataManager.loadProfileName(
            completion: { name in
                self.activityIndicator.stopAnimating()
                self.nameTextField.text = name
                self.nameTextField.isHidden = false
            },
            failure: {
                self.activityIndicator.stopAnimating()
                self.nameTextField.isHidden = false
            })
    }
    
    func loadProfileInfo() {
        gcdDataManager.loadProfileInfo(
            completion: { name in
                self.activityIndicator.stopAnimating()
                self.infoTextView.text = name
                self.infoTextView.isHidden = false
            },
            failure: {
                self.activityIndicator.stopAnimating()
                self.infoTextView.isHidden = false
            })
    }
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
        view.backgroundColor = theme.messageListViewBackgroundColor
        saveGCDButton.layer.backgroundColor = theme.navigationBarColor.cgColor
        saveOperationsButton.layer.backgroundColor = theme.navigationBarColor.cgColor
        nameTextField.textColor = theme.navigationBarTextColor
        infoTextView.textColor = theme.navigationBarTextColor
        infoTextView.backgroundColor = view.backgroundColor
        navigationController?.navigationBar.barTintColor = theme.navigationBarColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
    }
}

protocol AvatarUpdaterDelegate: class {
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
    
    private func setNameFieldPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: padding))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        nameTextField.rightView = paddingView
        nameTextField.rightViewMode = .always
    }
    
}
