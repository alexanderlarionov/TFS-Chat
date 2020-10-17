//
//  ChannelModel.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation

struct ChannelModel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}
