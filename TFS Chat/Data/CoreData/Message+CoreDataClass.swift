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
    
    convenience init(context: NSManagedObjectContext, model: MessageModel, channel: ChannelDb) {
        self.init(context: context)
        self.content = model.content
        self.created = model.created
        self.senderId = model.senderId
        self.senderName = model.senderName
        self.channel = channel
    }
    
    override public var description: String {
        return "content: \(content), created: \(created), senderId: \(senderId), senderName: \(senderName), channel: \(channel.id)"
    }
    
}
