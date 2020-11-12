//
//  ConversationViewCell.swift
//  TFS Chat
//
//  Created by dmitry on 30.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 10
    }
    
    func configure(with model: MessageDataModel) {
        messageLabel.text = model.content
        nameLabel.text = model.senderName
        dateLabel.text = DateUtil.formatForView(date: model.created)
    }
    
    func setColor(for identifier: String) {
        let theme = ThemeManager.instance.currentTheme
        backgroundColor = theme.messageListViewBackgroundColor
        if identifier == "SentMessageCell" {
            messageView.backgroundColor = theme.sentMessageBackgroundColor
            messageLabel.textColor = theme.sentMessageTextColor
            nameLabel.textColor = theme.sentMessageTextColor
            dateLabel.textColor = theme.sentMessageTextColor
        } else {
            messageView.backgroundColor = theme.recievedMessageBackgroundColor
            messageLabel.textColor = theme.recievedMessageTextColor
            nameLabel.textColor = theme.recievedMessageTextColor
            dateLabel.textColor = theme.recievedMessageTextColor
        }
    }
}
