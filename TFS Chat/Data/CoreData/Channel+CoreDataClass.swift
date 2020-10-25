//
//  Channel+CoreDataClass.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
//

import Foundation
import CoreData

public class ChannelDb: NSManagedObject {

    func setupFromModel(model: ChannelModel) {
        self.id = model.identifier
        self.name = model.name
        self.lastMessage = model.lastMessage
        self.lastActivity = model.lastActivity
    }
}
