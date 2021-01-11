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
    
    var fetchedResultsController: NSFetchedResultsController<ChannelDb>!
    var apiService: ApiServiceProtocol!
    var storageService: StorageServiceProtocol!
    var presentationAssembly: PresentationAssemblyProtocol!
    var gcdDataManager: FileStorageServiceProtocol!
    //TODO get rid of force unwrap, move frc to model
    
    let animationLayer = CAEmitterLayer()
    let transition = TransitionAnimation()
    
    func injectDependencies(presentationAssembly: PresentationAssembly,
                            storageService: StorageServiceProtocol,
                            apiService: ApiServiceProtocol,
                            gcdDataManager: FileStorageServiceProtocol) {
        self.storageService = storageService
        self.apiService = apiService
        self.presentationAssembly = presentationAssembly
        self.gcdDataManager = gcdDataManager
        self.fetchedResultsController = storageService.getChannelsFRC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        storageService.performFetch(for: fetchedResultsController)
        apiService.subscribeOnChannelsChanges { channels in
            self.storageService.saveChannels(channelModels: channels)
        }
        profileLogoView.finishViewLoading(dataManager: gcdDataManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
    }
    
    @IBAction func longPressedAction(_ sender: UILongPressGestureRecognizer) {
        showTinkoffAnimation(sender: sender, layer: animationLayer)
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
            apiService.deleteChannel(channelId: channel.id)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = fetchedResultsController.object(at: indexPath)
        let messageListController = presentationAssembly.messageListControler(channelId: channel.id, title: channel.name)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(messageListController, animated: true)
    }
    
    @IBAction func profileIconTapped(_ sender: UITapGestureRecognizer) {
        let profileController = presentationAssembly.profileController(delegate: self)
        profileController.transitioningDelegate = self
        self.present(profileController, animated: true)
    }
    
    @IBAction func gearIconTapped(_ sender: Any) {
        let themeController = presentationAssembly.themesController()
        navigationController?.pushViewController(themeController, animated: true)
    }
    
    @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Channel", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            if let name = alert.textFields?[0].text {
                let channel = ChannelDataModel(name: name, lastMessage: nil, lastActivity: nil)
                self.apiService.addChannel(channel: channel)
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
        tableView.separatorColor = theme.channelListCellTextColor
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

extension ChannelListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
