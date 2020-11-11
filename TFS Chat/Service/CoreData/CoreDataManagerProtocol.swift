//
//  CoreDataManagerProtocol.swift
//  TFS Chat
//
//  Created by dmitry on 11.11.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol: class {
    
    static var instance: CoreDataManagerProtocol { get }
    var viewContext: NSManagedObjectContext { get }
    
    func saveChannels(channelModels: [ChannelModel])
    
    func saveMessages(messageModels: [MessageModel], channelId: String)
    
    func fetchChannel(by id: String, in context: NSManagedObjectContext) -> ChannelDb?
}
