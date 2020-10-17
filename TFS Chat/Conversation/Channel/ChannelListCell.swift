//
//  ConversationListCellTableViewCell.swift
//  TFS Chat
//
//  Created by dmitry on 29.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ChannelListCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    func configure(with model: ChannelModel) {
        nameLabel.text = model.name
        setDate(for: model)
        setMessage(for: model)
        setColor()
    }
    
    private func setDate(for model: ChannelModel) {
        let formatter = DateFormatter()
        
        if let lastActivity = model.lastActivity {
            if Calendar.current.isDateInToday(lastActivity) {
                formatter.dateFormat = "HH:mm"
                dateLabel.text = formatter.string(from: lastActivity)
            } else {
                formatter.dateFormat = "dd MMM"
                dateLabel.text = formatter.string(from: lastActivity)
            }
        } else {
            dateLabel.text = nil
        }
    }
    
    private func setMessage(for model: ChannelModel) {
        let fontSize = messageLabel.font.pointSize
        
        if let lastMessage = model.lastMessage {
            messageLabel.text = lastMessage
            messageLabel.font = UIFont.systemFont(ofSize: fontSize)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: fontSize)
        }
    }
    
    private func setColor() {
        let theme = ThemeManager.instance.currentTheme
        backgroundColor = theme.conversationListCellColor
        nameLabel.textColor = theme.conversationListCellNameColor
        dateLabel.textColor = theme.conversationListCellTextColor
        messageLabel.textColor = theme.conversationListCellTextColor
    }
    
}
