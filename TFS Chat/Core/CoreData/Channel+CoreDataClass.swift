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
    
    convenience init(context: NSManagedObjectContext, model: ChannelDataModel) {
        self.init(context: context)
        self.id = model.identifier
        self.name = model.name
        self.lastMessage = model.lastMessage
        self.lastActivity = model.lastActivity
    }
    
    override public var description: String {
        return "identifier: \(id), name: \(name), lastMessage: \(String(describing: lastMessage)), lastActivity: \(String(describing: lastActivity))"
    }
    
    func toChannelModel() -> ChannelDataModel {
        return ChannelDataModel(name: self.name, lastMessage: self.lastMessage, lastActivity: self.lastActivity)
    }
    
}
