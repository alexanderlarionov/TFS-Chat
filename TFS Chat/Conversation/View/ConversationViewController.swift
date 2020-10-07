//
//  ConversationViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ConversationViewController: UITableViewController {
    
    let data = FakeData.conversationData;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = data[indexPath.row]
        
        if cellModel.type == .sent {
            return configureCell(indexPath: indexPath, identifier: "SentMessageCell", model: cellModel)
        } else {
            return configureCell(indexPath: indexPath, identifier: "RecievedMessageCell", model: cellModel)
        }
    }
    
    private func configureCell(indexPath: IndexPath, identifier: String, model: MessageCellModel) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationViewCell else { return UITableViewCell()}
        cell.setColor(for: identifier)
        cell.configure(with: model)
        return cell
    }
    
}

extension ConversationViewController: Themable {
    func adjustViewForCurrentTheme() {
        tableView.backgroundColor = ThemeManager.currentTheme().conversationViewBackgroundColor
        tableView.reloadData()
    }
}
