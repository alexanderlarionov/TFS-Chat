//
//  ConversationViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageView: UIView!
    
    var messages = [MessageModel]()
    var channelId: String?
    let senderID = UIDevice.current.identifierForVendor?.uuidString
    
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
        updateMessages()
        adjustViewForCurrentTheme()
    }
    
    func updateMessages() {
        guard let channelId = channelId else { return }
        messages.removeAll()
        FirestoreManager.getMessages(channelId: channelId,
                                     completion: { [weak self] messages in
                                        self?.messages = messages
                                        self?.sortMessagesByDate()
                                        self?.tableView.reloadData()
                                     }
        )
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let channelId = channelId else { return }
        guard let senderID = senderID else { return }
        guard let content = messageTextField.text, content != "" else { return }
        let message = MessageModel(content: content, created: Date(), senderId: senderID, senderName: "Dmitry Akatev")
        FirestoreManager.addMessage(channelId: channelId,
                                    message: message,
                                    completion: { [weak self] in
                                        self?.dismissKeyboard()
                                        self?.messageTextField.text = ""
                                        self?.updateMessages()
                                    })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: messageView.frame.size.height))
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = messages[indexPath.row]
        
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
    
    private func sortMessagesByDate() {
        messages.sort { $0.created < $1.created }
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
