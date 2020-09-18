//
//  ViewController.swift
//  TFS Chat
//
//  Created by dmitry on 11.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var profileUIView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printStateInfo(#function)
        profileUIView.layer.cornerRadius = profileUIView.frame.width / 2;
        profileImageView.layer.cornerRadius = profileUIView.layer.cornerRadius;
        saveButton.layer.cornerRadius = 14;
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            LoggingUtil.debugPrint("Photo Library is not available")
            return
        }
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }
    }
}

extension ViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printStateInfo(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printStateInfo(#function)
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
        LoggingUtil.debugPrint("Method \(methodName) of ViewController was called \n")
    }
}

