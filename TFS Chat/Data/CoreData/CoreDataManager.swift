//
//  CoreDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    private init() {}
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Chat")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Something went wrong: \(error)")
            }
        }
        print("DB directory: ", FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found!")
        return container
    }()
    
    static var saveContext: NSManagedObjectContext  = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
        return context
    }()
    
    static func saveData() {
        if saveContext.hasChanges {
            do {
                try saveContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
                saveContext.rollback()
            }
        }
    }
    
    static func fetchChannel(by id: String) -> ChannelDb? {
        let request = ChannelDb.createFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let channels = try saveContext.fetch(request)
            return channels.first
        } catch {
            print("Fetch failed: \(error)")
            return nil
        }
    }
}
