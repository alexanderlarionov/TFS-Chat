//
//  ConversationsListViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit
import CoreData

class ChannelListViewController: UITableViewController {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    
    let selectedCellView = UIView()
    let fetchedResultsController = StorageService.instance.getChannelsFRC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        StorageService.instance.performFetch(for: fetchedResultsController)
        ApiService.instance.subscribeOnChannelsChanges { channels in
            StorageService.instance.saveChannels(channelModels: channels)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelListCell", for: indexPath) as? ChannelListCell else { return UITableViewCell() }
        
        let cellModel = fetchedResultsController.object(at: indexPath).toChannelModel()
        cell.configure(with: cellModel)
        cell.selectedBackgroundView = selectedCellView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let channel = fetchedResultsController.object(at: indexPath)
            ApiService.instance.deleteChannel(channelId: channel.id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let target = segue.destination as? MessageListViewController {
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            target.title = fetchedResultsController.object(at: selectedPath).name
            target.channelId = fetchedResultsController.object(at: selectedPath).id
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
                ApiService.instance.addChannel(channel: channel)
            }
        }
        alert.addAction(createAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
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

extension ChannelListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let path = newIndexPath else { return }
            tableView.insertRows(at: [path], with: .automatic)
            
        case .delete:
            guard let path = indexPath else { return }
            tableView.deleteRows(at: [path], with: .automatic)
            
        case .update:
            guard let path = indexPath else { return }
            self.tableView.reloadRows(at: [path], with: .automatic)
            
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath  else { return }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
