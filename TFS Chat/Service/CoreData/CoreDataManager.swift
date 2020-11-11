//
//  CoreDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
import Foundation
import CoreData

class CoreDataManager: CoreDataManagerProtocol {
    
    static var instance: CoreDataManagerProtocol = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Chat")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Persistent store not loaded: \(error)")
            }
        }
        viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        
        print("DB directory: ", FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    func saveChannels(channelModels: [ChannelModel]) {
        saveData { context in
            channelModels.forEach {
                if let savedChannel = self.fetchChannel(by: $0.identifier, in: context) {
                    //without this if condition core data triggers update on each cell (probably because of fault mechanism)
                    if $0.lastMessage != savedChannel.lastMessage || $0.lastActivity != savedChannel.lastActivity {
                        _ = ChannelDb(context: context, model: $0)
                    }
                } else {
                    _ = ChannelDb(context: context, model: $0)
                }
            }
            self.cleanDeletedChannels(upToDateChannels: channelModels, context: context)
        }
    }
    
    func saveMessages(messageModels: [MessageModel], channelId: String) {
        saveData { context in
            if let channel = self.fetchChannel(by: channelId, in: context) {
                messageModels.forEach { _ = MessageDb(context: context, model: $0, channel: channel) }
            }
        }
    }
    
    func fetchChannel(by id: String, in context: NSManagedObjectContext) -> ChannelDb? {
        let predicate = NSPredicate(format: "id == %@", id)
        let channels = fetchChannels(by: predicate, in: context)
        return channels?.first
    }
    
    private func saveData(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            self.addObserver(for: context)
            context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                    self.printDbStat()
                } catch {
                    print("An error occurred while saving: \(error)")
                    context.rollback()
                }
            }
        }
    }
    
    private func fetchChannels(by predicate: NSPredicate?, in context: NSManagedObjectContext) -> [ChannelDb]? {
        let request = ChannelDb.createFetchRequest()
        request.predicate = predicate
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            return nil
        }
    }
    
    private func cleanDeletedChannels(upToDateChannels: [ChannelModel], context: NSManagedObjectContext) {
        let deletionPredicate = NSPredicate(format: "NOT (id IN %@)", upToDateChannels.map { $0.identifier})
        if let channelsToDelete = self.fetchChannels(by: deletionPredicate, in: context) {
            print("Channels deleted: ", channelsToDelete)
            channelsToDelete.forEach { context.delete($0) }
        }
    }
    
    private func addObserver(for context: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.managedObjectContextObjectsDidChange(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: context)
    }
    
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
           inserts.count > 0 {
            print("Objects inserted in context: ", inserts.count)
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            print("Objects updated in context: ", updates.count)
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Objects deleted from context: ", deletes.count)
        }
    }
    
    private func printDbStat() {
        persistentContainer.viewContext.perform {
            do {
                let channelsCount = try self.viewContext.count(for: ChannelDb.createFetchRequest())
                print("\n There are \(channelsCount) channels in DB: ")
                let channels = try self.viewContext.fetch(ChannelDb.createFetchRequest())
                channels.forEach { print("<\($0)>") }
                
                let messagesCount = try self.viewContext.count(for: MessageDb.fetchRequest())
                print("\n There are \(messagesCount) messages in DB: ")
                let messages = try self.viewContext.fetch(MessageDb.createFetchRequest())
                messages.forEach { print("<\($0)>") }
            } catch {
                print("Error during fetch data for statistic: ", error.localizedDescription)
            }
        }
    }
}
