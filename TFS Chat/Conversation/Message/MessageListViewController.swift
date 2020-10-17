//
//  ConversationViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit
import Firebase

class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageView: UIView!
    
    var data = [MessageModel]()
    var channelId: String?
    let senderID = "hardcodeId123"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFirestoreData()
        adjustViewForCurrentTheme()
    }
    
    func getFirestoreData() {
        data.removeAll()
        guard let channelId = channelId else { return }
        FirestoreManager.root.document(channelId).collection("messages").getDocuments { snapshot, error in
            if let error = error {
                print("error during query " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                for message in snapshot.documents {
                    let data = message.data()
                    let content = data["content"] as? String ?? ""
                    let senderName = data["senderName"] as? String ?? ""
                    let senderId = data["senderId"] as? String ?? ""
                    var created = Date()
                    if let createdTimestamp = data["created"] as? Timestamp {
                        created = createdTimestamp.dateValue()
                    }
                    
                    let dataModel = MessageModel(content: content, created: created, senderId: senderId, senderName: senderName)
                    self.data.append(dataModel)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let content = messageTextField.text, content != "" else {
            print("empty message, not sent")
            return }
        guard let channelId = channelId else { return }
        FirestoreManager.root.document(channelId).collection("messages").addDocument(data: [
            "content": content,
            "created": Date(),
            "senderId": senderID,
            "senderName": "Anonymous"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("message sent")
                self.dismissKeyboard()
                self.messageTextField.text = ""
                self.getFirestoreData()
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: messageView.frame.size.height))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = data[indexPath.row]
        
        if cellModel.senderId == senderID {
            return configureCell(indexPath: indexPath, identifier: "SentMessageCell", model: cellModel)
        } else {
            return configureCell(indexPath: indexPath, identifier: "RecievedMessageCell", model: cellModel)
        }
    }
    
    private func configureCell(indexPath: IndexPath, identifier: String, model: MessageModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageViewCell else { return UITableViewCell()}
        cell.setColor(for: identifier)
        cell.configure(with: model)
        return cell
    }
    
}

extension MessageListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension MessageListViewController: Themable {
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.instance.currentTheme
        tableView.backgroundColor = theme.messageListViewBackgroundColor
        messageView.backgroundColor = theme.navigationBarColor
        messageTextField.backgroundColor = theme.messageListViewBackgroundColor
        messageTextField.textColor = theme.recievedMessageTextColor
        tableView.tableFooterView?.backgroundColor = theme.messageListViewBackgroundColor
        tableView.reloadData()
    }
}
