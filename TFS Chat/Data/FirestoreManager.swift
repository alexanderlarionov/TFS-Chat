//
//  FirestoreManager.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import FirebaseFirestore

class FirestoreManager {
    
    static let instance = FirestoreManager()
    private let root = Firestore.firestore().collection("channels")
    var messageListener: ListenerRegistration?
    
    private init() {}
    
    func listenMessagesSnapshot(channelId: String, completion: @escaping ([MessageModel]) -> Void) {
        messageListener = root.document(channelId).collection("messages").addSnapshotListener { snapshot, error in
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
                print(messages.count, " messages from firestore")
                completion(messages)
            }
        }
    }
    
    func addMessage(channelId: String, message: MessageModel, completion: @escaping () -> Void) {
        root.document(channelId).collection("messages").addDocument(data: message.toFirebaseDictionary()) { error in
            if let error = error {
                print("Add message error: " + error.localizedDescription)
            } else {
                completion()
            }
        }
    }
    
    func listenSnapshotChannels(completion: @escaping ([ChannelModel]) -> Void) {
        root.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Load channels error: " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                var channels = [ChannelModel]()
                for channel in snapshot.documents {
                    if let dataModel = ChannelModel(firebaseData: channel) {
                        channels.append(dataModel)
                    }
                }
                print(channels.count, " channels from firestore")
                completion(channels)
            }
        }
    }
    
    func addChannel(channel: ChannelModel) {
        root.addDocument(data: channel.toFirebaseDictionary()) { error in
            if let error = error {
                print("Add channel error: " + error.localizedDescription)
            }
        }
    }
    
    func removeMessageListener() {
        messageListener?.remove()
    }
}
