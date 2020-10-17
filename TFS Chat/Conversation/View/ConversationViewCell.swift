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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 10
    }
    
    func configure(with model: MessageModel) {
        messageLabel.text = model.content
        nameLabel.text = model.senderName
        
        let date = model.created
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            dateLabel.text = formatter.string(from: date)
        } else {
            formatter.dateFormat = "dd MMM"
            dateLabel.text = formatter.string(from: date)
        }
    }
    
    func setColor(for identifier: String) {
        let theme = ThemeManager.instance.currentTheme
        backgroundColor = theme.conversationViewBackgroundColor
        //        if identifier == "SentMessageCell" {
        //            messageView.backgroundColor = theme.sentMessageBackgroundColor
        //            messageLabel.textColor = theme.sentMessageTextColor
        //        } else {
        messageView.backgroundColor = theme.recievedMessageBackgroundColor
        messageLabel.textColor = theme.recievedMessageTextColor
        nameLabel.textColor = theme.recievedMessageTextColor
        dateLabel.textColor = theme.recievedMessageTextColor
    }
}
