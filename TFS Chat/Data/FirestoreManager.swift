//
//  FirestoreManager.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import FirebaseFirestore

struct FirestoreManager {
    
    static let root = Firestore.firestore().collection("channels")
    static var messageListener: ListenerRegistration?
    static var channelListener: ListenerRegistration?
    let coreDataManager: CoreDataManager!
    
    private init() {
        coreDataManager = CoreDataManager()
    }
    
    static func listenMessagesSnapshot(channelId: String, completion: @escaping ([MessageModel]) -> Void) {
        messageListener = FirestoreManager.root.document(channelId).collection("messages").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Load messages error: " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var messages = [MessageModel]()
                for message in snapshot.documents {
                    if let dataModel = MessageModel(firebaseData: message) {
                        messages.append(dataModel)
                    }
                }
                completion(messages)
            }
        }
    }
    
    static func addMessage(channelId: String, message: MessageModel, completion: @escaping () -> Void) {
        FirestoreManager.root.document(channelId).collection("messages").addDocument(data: message.toFirebaseDictionary()) { error in
            if let error = error {
                print("Add message error: " + error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    static func listenSnapshotChannels(completion: @escaping ([ChannelModel]) -> Void) {
        channelListener = FirestoreManager.root.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Load channels error: " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var channels = [ChannelModel]()
                for channel in snapshot.documents {
                    if let dataModel = ChannelModel(firebaseData: channel) {
                        channels.append(dataModel)
                        
                        let channel = Channel(context: CoreDataManager.persistentContainer.viewContext)
                        channel.id = dataModel.identifier
                        channel.name = dataModel.name
                        channel.lastMessage = dataModel.lastMessage
                        channel.lastActivity = dataModel.lastActivity
                        CoreDataManager.saveContext()
                    }
                }
                completion(channels)
            }
        }
    }
    
    static func addChannel(channel: ChannelModel) {
        FirestoreManager.root.addDocument(data: channel.toFirebaseDictionary()) { error in
            if let error = error {
                print("Add channel error: " + error.localizedDescription)
            }
        }
    }
}
