//
//  ConversationViewCell.swift
//  TFS Chat
//
//  Created by dmitry on 30.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import UIKit

class ConversationViewCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageView: UIView!
    
    override func awakeFromNib() {
        messageView.layer.cornerRadius = 10;
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
    }
    
    func setColor(for identifier: String) {
        let theme = ThemeManager.instance.currentTheme
        backgroundColor = theme.conversationViewBackgroundColor
        if identifier == "SentMessageCell" {
            messageView.backgroundColor = theme.sentMessageBackgroundColor
            messageLabel.textColor = theme.sentMessageTextColor
        } else {
            messageView.backgroundColor = theme.recievedMessageBackgroundColor
            messageLabel.textColor = theme.recievedMessageTextColor
        }
    }
}
