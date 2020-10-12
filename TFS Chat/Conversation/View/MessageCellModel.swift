//
//  MessageCellModel.swift
//  TFS Chat
//
//  Created by dmitry on 30.09.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

struct MessageCellModel {
    let text: String
    let type: MessageType
    
    enum MessageType {
        case sent, recieved
    }
}
