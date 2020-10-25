//
//  Message+CoreDataClass.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
//

import Foundation
import CoreData

public class MessageDb: NSManagedObject {
    
    func setupFromModel(model: MessageModel) {
        self.content = model.content
        self.created = model.created
        self.senderId = model.senderId
        self.senderName = model.senderName
    }
}
