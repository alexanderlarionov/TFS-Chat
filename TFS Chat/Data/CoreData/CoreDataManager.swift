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
    private init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Something went wrong: \(error)")
            }
        }
        print("DB directory: ", FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found!")
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    func saveChannels(channelModels: [ChannelModel]) {
        //TODO check deleted channels
        saveData { context in
            for model in channelModels {
                _ = ChannelDb(context: context, model: model)
            }
        }
    }
    
    func saveMessages(messageModels: [MessageModel], channelId: String) {
        saveData { context in
            if let channel = self.fetchChannel(by: channelId, in: context) {
                for model in messageModels {
                    _ = MessageDb(context: context, model: model, channel: channel)
                }
            }
        }
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
    
    func fetchChannel(by id: String, in context: NSManagedObjectContext) -> ChannelDb? {
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
            //inserts.forEach {print("inserted: ", $0) }
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>,
           updates.count > 0 {
            print("Objects updated in context: ", updates.count)
            //updates.forEach {print("updated: ", $0) }
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>,
           deletes.count > 0 {
            print("Objects deleted from context: ", deletes.count)
            //deletes.forEach {print("deleted: ", $0) }
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
