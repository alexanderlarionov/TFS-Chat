//
//  CoreDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
import Foundation
import CoreData

protocol StorageServiceProtocol {
    
    func saveChannels(channelModels: [ChannelModel])
    
    func saveMessages(messageModels: [MessageModel], channelId: String)
    
    func fetchChannel(by id: String) -> ChannelDb?
    
    func getChannelsFRC() -> NSFetchedResultsController<ChannelDb>
    
    func getMessagesFRC(channelId: String) -> NSFetchedResultsController<MessageDb>
    
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>)
}

class StorageService: StorageServiceProtocol {
    
    static let instance = StorageService()
    lazy var viewContext = CoreDataStack.instance.viewContext
 
    func saveChannels(channelModels: [ChannelModel]) {
        CoreDataStack.instance.saveChannels(channelModels: channelModels)
    }
    
    func saveMessages(messageModels: [MessageModel], channelId: String) {
        CoreDataStack.instance.saveMessages(messageModels: messageModels, channelId: channelId)
    }
    
    func fetchChannel(by id: String) -> ChannelDb? {
        return CoreDataStack.instance.fetchChannel(by: id, in: viewContext)
    }
    
    func getChannelsFRC() -> NSFetchedResultsController<ChannelDb> {
        let fetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 10
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func getMessagesFRC(channelId: String) -> NSFetchedResultsController<MessageDb> {
        let fetchRequest: NSFetchRequest<MessageDb> = MessageDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 10
        
        if let channel = StorageService.instance.fetchChannel(by: channelId) {
            let predicate = NSPredicate(format: "channel == %@", channel)
            fetchRequest.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: StorageService.instance.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>) {
        do {
            try frc.performFetch()
        } catch {
            print("Error during fetch: ", error.localizedDescription)
        }
    }
    
}
