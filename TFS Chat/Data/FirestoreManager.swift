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
    
    static func getMessages(channelId: String, completion: @escaping ([MessageModel]) -> Void) {
        var messages = [MessageModel]()
        FirestoreManager.root.document(channelId).collection("messages").getDocuments { snapshot, error in
            if let error = error {
                print("Load messages error: " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
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
    
    static func getChannels(completion: @escaping ([ChannelModel]) -> Void) {
        var channels = [ChannelModel]()
        FirestoreManager.root.getDocuments { snapshot, error in
            if let error = error {
                print("Load channels error: " + error.localizedDescription)
            } else {
                guard let snapshot = snapshot else { return }
                for channel in snapshot.documents {
                    if let dataModel = ChannelModel(firebaseData: channel) {
                        channels.append(dataModel)
                    }
                }
                completion(channels)
            }
        }
    }
    
    static func addChannel(channel: ChannelModel, completion: @escaping () -> Void) {
        FirestoreManager.root.addDocument(data: channel.toFirebaseDictionary()) { error in
            if let error = error {
                print("Add channel error: " + error.localizedDescription)
            } else {
                completion()
            }
        }
    }
}
