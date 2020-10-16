//
//  ConversationListCellTableViewCell.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ConversationListCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    func configure(with model: ConversationCellModel) {
        nameLabel.text = model.name
        setDate(for: model)
        setMessage(for: model)
        setColor(for: model)
    }
    
    private func setDate(for model: ConversationCellModel) {
        let formatter = DateFormatter()
        
        if model.message == "" {
            dateLabel.text = nil
        } else if Calendar.current.isDateInToday(model.date) {
            formatter.dateFormat = "HH:mm"
            dateLabel.text = formatter.string(from: model.date)
        } else {
            formatter.dateFormat = "dd MMM"
            dateLabel.text = formatter.string(from: model.date)
        }
    }
    
    private func setMessage(for model: ConversationCellModel) {
        let fontSize = messageLabel.font.pointSize
        if model.message == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: fontSize)
        } else if model.hasUnreadMessages {
            messageLabel.text = model.message
            messageLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            messageLabel.text = model.message
            messageLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    private func setColor(for model: ConversationCellModel) {
        let theme = ThemeManager.instance.currentTheme
        backgroundColor = model.isOnline ? theme.conversationListCellOnlineColor : theme.conversationListCellOfflineColor
        nameLabel.textColor = theme.conversationListCellNameColor
        dateLabel.textColor = theme.conversationListCellTextColor
        messageLabel.textColor = theme.conversationListCellTextColor
    }
    
}
