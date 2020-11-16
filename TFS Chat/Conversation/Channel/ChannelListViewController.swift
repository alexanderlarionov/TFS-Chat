//
//  ConversationsListViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ChannelListViewController: UITableViewController {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    
    var channels = [ChannelModel]()
    let selectedCellView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
        FirestoreManager.listenSnapshotChannels(completion: { [weak self] channels in
            self?.channels = channels
            self?.sortChannelsByDate()
            self?.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell", for: indexPath) as? ChannelListCell else { return UITableViewCell() }
        
        let cellModel = channels[indexPath.row]
        cell.configure(with: cellModel)
        cell.selectedBackgroundView = selectedCellView
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? MessageListViewController {
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            target.title = channels[selectedPath.row].name
            target.channelId = channels[selectedPath.row].identifier
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
    
    @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Channel", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            if let name = alert.textFields?[0].text {
                let channel = ChannelModel(name: name, lastMessage: nil, lastActivity: nil)
                FirestoreManager.addChannel(channel: channel)
            }
        }
        alert.addAction(createAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
    }
    
    private func sortChannelsByDate() {
        channels.sort {
            $0.lastActivity ?? Date(timeIntervalSince1970: 0)
                > $1.lastActivity ?? Date(timeIntervalSince1970: 0)
        }
    }
    
}

extension ChannelListViewController: AvatarUpdaterDelegate {
    func updateAvatar(to image: UIImage) {
        profileLogoView.setImage(image)
    }
}

extension ChannelListViewController: Themable {
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
        
        tableView.backgroundColor = theme.channelListBackgroundColor
        selectedCellView.backgroundColor = theme.navigationBarColor
        tableView.reloadData()
    }
}
