//
//  ConversationViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit
import Firebase

class MessageListViewController: UITableViewController {
    
    var data = [MessageModel]()
    var channelId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = data[indexPath.row]
        return configureCell(indexPath: indexPath, identifier: "RecievedMessageCell", model: cellModel)
        //        if cellModel.type == .sent {
        //            return configureCell(indexPath: indexPath, identifier: "SentMessageCell", model: cellModel)
        //        } else {
        //}
    }
    
    private func configureCell(indexPath: IndexPath, identifier: String, model: MessageModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageViewCell else { return UITableViewCell()}
        cell.setColor(for: identifier)
        cell.configure(with: model)
        return cell
    }
    
}

extension MessageListViewController: Themable {
    func adjustViewForCurrentTheme() {
        tableView.backgroundColor = ThemeManager.instance.currentTheme.conversationViewBackgroundColor
        tableView.reloadData()
    }
}
