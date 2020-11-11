//
//  Channel+CoreDataProperties.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
//

import Foundation
import CoreData

extension ChannelDb {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ChannelDb> {
        return NSFetchRequest<ChannelDb>(entityName: "ChannelDb")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension ChannelDb {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDb)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDb)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
