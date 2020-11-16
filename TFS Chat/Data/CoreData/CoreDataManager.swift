//
//  CoreDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let instance = CoreDataManager()
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.managedObjectContextObjectsDidChange(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                               object: mainContext)
    }
    
    func saveChannels(channelModels: [ChannelModel]) {
        performSave { context in
            for model in channelModels {
                _ = ChannelDb(context: context, model: model)
            }
        }
    }
    
    func saveMessages(messageModels: [MessageModel], channelId: String) {
        performSave { context in
            if let channel = self.fetchChannel(by: channelId, in: context) {
                for model in messageModels {
                    _ = MessageDb(context: context, model: model, channel: channel)
                }
            }
        }
    }
    
    private func fetchChannel(by id: String, in context: NSManagedObjectContext) -> ChannelDb? {
        let request = ChannelDb.createFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let channels = try context.fetch(request)
            return channels.first
        } catch {
            print("Fetch failed: \(error)")
            return nil
        }
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = Bundle.main.url(forResource: "Chat", withExtension: "momd") else {
            fatalError("Model not found")
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Model not created")
        }
        return managedObjectModel
    }()
    
    private lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
        let storeUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("Chat.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
        return coordinator
    }()
    
    private lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistantStoreCoordinator
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = writeContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private func saveContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }
    
    private func performSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = saveContext()
        context.performAndWait {
            block(context)
            if context.hasChanges {
                performSave(in: context)
            }
        }
        printDbStat()
    }
    
    private func performSave(in context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        if let parent = context.parent { performSave(in: parent) }
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
        mainContext.perform {
            do {
                let channelsCount = try self.mainContext.count(for: ChannelDb.createFetchRequest())
                print("\n There are \(channelsCount) channels in DB: ")
                let channels = try self.mainContext.fetch(ChannelDb.createFetchRequest())
                channels.forEach { print("<\($0)>") }
                
                let messagesCount = try self.mainContext.count(for: MessageDb.fetchRequest())
                print("\n There are \(messagesCount) messages in DB: ")
                let messages = try self.mainContext.fetch(MessageDb.createFetchRequest())
                messages.forEach { print("<\($0)>") }
            } catch {
                print("Error during fetch data for statistic: ", error.localizedDescription)
            }
        }
    }
}
