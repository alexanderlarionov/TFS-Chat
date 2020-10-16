//
//  ConversationsListViewController.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    @IBOutlet var profileLogoView: ProfileLogoView!
    
    let themeManager = ThemeManager()
    let data = FakeData.conversationListData;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustViewForCurrentTheme()
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
        if let target = segue.destination as? ConversationViewController {
            guard let selectedPath = tableView.indexPathForSelectedRow else { return }
            target.title = data[selectedPath.section][selectedPath.row].name
            navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        } else if let target = segue.destination as? ThemesViewController {
            target.title = "Settings"
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Chat", style: .plain, target: nil, action: nil)
            //target.themesPickerDelegate = self.themeManager
            target.applyThemeBlock = { theme in
                self.themeManager.applyTheme(theme)
            }
        }
        segue.destination.navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func unwindToConversationList(segue: UIStoryboardSegue) {
    }
    
}

extension ConversationsListViewController: Themable {
    func adjustViewForCurrentTheme() {
        let theme = ThemeManager.currentTheme()
        let backgroundColor = theme.navigationBarColor
        let textColor = theme.navigationBarTextColor
        
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.barTintColor = backgroundColor
        navBar.titleTextAttributes = [.foregroundColor: textColor]
        navBar.largeTitleTextAttributes = [.foregroundColor: textColor]
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = backgroundColor
            navBarAppearance.titleTextAttributes = [.foregroundColor: textColor]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
            navBar.standardAppearance = navBarAppearance
            navBar.scrollEdgeAppearance = navBarAppearance
        }
        
        tableView.backgroundColor = theme.conversationListBackgroundColor
        tableView.reloadData()
    }
}

