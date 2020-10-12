//
//  ConversationsListViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    let data = FakeData.conversationListData;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        if section == 0 {
            title = "Online"
        } else if section == 1 {
            title = "History"
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        let cellModel = data[indexPath.section][indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let target = segue.destination as? ConversationViewController else { return }
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        target.title = data[selectedPath.section][selectedPath.row].name
        target.navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
    }
    
}
