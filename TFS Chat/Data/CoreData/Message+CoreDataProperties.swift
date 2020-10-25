//
//  Message+CoreDataProperties.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
//

import Foundation
import CoreData

extension MessageDb {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDb> {
        return NSFetchRequest<MessageDb>(entityName: "MessageDb")
    }

    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDb
    
}
