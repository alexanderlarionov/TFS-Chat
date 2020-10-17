//
//  ConversationsListViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    
    var data = [ChannelModel]()
    
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
        FirestoreManager.root.getDocuments { snapshot, error in
            if let error = error {
                print("error during query " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                for channel in snapshot.documents {
                    let id = channel.documentID
                    let data = channel.data()
                    let name = data["name"] as? String ?? "noname"
                    let lastMessage = data["lastMessage"] as? String
                    
                    var lastActivity: Date?
                    if let lastActivityTimestamp = data["lastActivity"] as? Timestamp {
                        lastActivity = lastActivityTimestamp.dateValue()
                    }
                    
                    let dataModel = ChannelModel(identifier: id, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        let cellModel = data[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? ConversationViewController {
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            target.title = data[selectedPath.row].name
            target.channelId = data[selectedPath.row].identifier
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        } else if let target = segue.destination as? ThemesViewController {
            target.title = "Settings"
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
            //target.themesPickerDelegate = ThemeManager.instance
            target.applyThemeBlock = { theme in
                ThemeManager.instance.applyTheme(theme)
            }
        } else if let target = segue.destination as? UINavigationController {
            guard let profileController = target.viewControllers.first as? ProfileViewController else { return }
            profileController.avatarUpdaterDelegate = self
        }
        segue.destination.navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
    }
    
}

extension ConversationsListViewController: AvatarUpdaterDelegate {
    func updateAvatar(to image: UIImage) {
        profileLogoView.setImage(image)
    }
}

extension ConversationsListViewController: Themable {
    func adjustViewForCurrentTheme() {
        guard let navBar = navigationController?.navigationBar else { return }
        let theme = ThemeManager.instance.currentTheme
        let backgroundColor = theme.navigationBarColor
        let textColor = theme.navigationBarTextColor
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = backgroundColor
            navBarAppearance.titleTextAttributes = [.foregroundColor: textColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navBar.barTintColor = backgroundColor
            navBar.titleTextAttributes = [.foregroundColor: textColor]
            navBar.largeTitleTextAttributes = [.foregroundColor: textColor]
        }
        
        tableView.backgroundColor = theme.conversationListBackgroundColor
        tableView.reloadData()
    }
}
