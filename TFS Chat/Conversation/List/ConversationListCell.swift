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
        }
        else {
            formatter.dateFormat = "dd MMM"
            dateLabel.text = formatter.string(from: model.date)
        }
    }
    
    private func setMessage(for model: ConversationCellModel) {
        let fontSize = messageLabel.font.pointSize
        if model.message == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont.italicSystemFont(ofSize: fontSize)
        }
        else if model.hasUnreadMessages {
            messageLabel.text = model.message
            messageLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            messageLabel.text = model.message
            messageLabel.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    private func setColor(for model: ConversationCellModel) {
        switch ThemesViewController.currentTheme {
        case .classic:
            backgroundColor = model.isOnline ? UIColor(red: 1.0, green: 1.0, blue: 0.65, alpha: 1.0) : UIColor.white
            nameLabel.textColor = UIColor.black
            dateLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
            messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .day:
            backgroundColor = model.isOnline ? UIColor(red: 0.58, green: 0.66, blue: 0.75, alpha: 1.00) : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            nameLabel.textColor = UIColor.black
            dateLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
            messageLabel.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        case .night:
            backgroundColor = model.isOnline ? UIColor(red: 0.118, green: 0.118, blue: 0.118, alpha: 1) : UIColor.black;
            nameLabel.textColor = UIColor.white
            dateLabel.textColor = UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
            messageLabel.textColor = UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
        }
    }
    
}


