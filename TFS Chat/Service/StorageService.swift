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
    
    func saveChannels(channelModels: [ChannelDataModel])
    
    func saveMessages(messageModels: [MessageDataModel], channelId: String)
    
    func fetchChannel(by id: String) -> ChannelDb?
    
    /// Протоколы используются для того чтобы оперировать абстракция;
    /// Здесь же есть использование очень конкретной реализции — NSFetchedResultsController;
    /// Отныне все классы реализующие протокол Сервиса Хранения обязаны иметь дело с CoreData;
    /// Так себе гибкость получается;
    
    func getChannelsFRC() -> NSFetchedResultsController<ChannelDb>
    
    func getMessagesFRC(channelId: String) -> NSFetchedResultsController<MessageDb>
    
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>)
}

class StorageService: StorageServiceProtocol {
    
    var storage: StorageProtocol
    
    init(storage: StorageProtocol) {
        self.storage = storage
    }
    
    func saveChannels(channelModels: [ChannelDataModel]) {
        storage.saveChannels(channelModels: channelModels)
    }
    
    func saveMessages(messageModels: [MessageDataModel], channelId: String) {
        storage.saveMessages(messageModels: messageModels, channelId: channelId)
    }
    
    func fetchChannel(by id: String) -> ChannelDb? {
        return storage.fetchChannel(by: id, in: storage.viewContext)
    }
    
    func getChannelsFRC() -> NSFetchedResultsController<ChannelDb> {
        let fetchRequest: NSFetchRequest<ChannelDb> = ChannelDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 10
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: storage.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func getMessagesFRC(channelId: String) -> NSFetchedResultsController<MessageDb> {
        let fetchRequest: NSFetchRequest<MessageDb> = MessageDb.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 10
        
        if let channel = fetchChannel(by: channelId) {
            let predicate = NSPredicate(format: "channel == %@", channel)
            fetchRequest.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: storage.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }
    
    func performFetch<T: NSManagedObject>(for frc: NSFetchedResultsController<T>) {
        do {
            try frc.performFetch()
        } catch {
            /// В логгер бы завернуть
            print("Error during fetch: ", error.localizedDescription)
        }
    }
    
}
