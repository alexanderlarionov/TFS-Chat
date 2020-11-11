//
//  FirestoreManager.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import FirebaseFirestore

protocol ApiServiceProtocol {
    
    func addMessage(channelId: String, message: MessageModel, completion: @escaping () -> Void)
    
    func addChannel(channel: ChannelModel)
    
    func subscribeOnMessagesChanges(channelId: String, completion: @escaping ([MessageModel]) -> Void)
    
    func subscribeOnChannelsChanges(completion: @escaping ([ChannelModel]) -> Void)
    
    func deleteChannel(channelId: String)
    
    func unsubscribeFromMessagesChanges()
}

class ApiService: ApiServiceProtocol {
    
    static let instance = ApiService()
    let firestoreClient = FirestoreClient.instance
    var messageListener: ListenerRegistration?
    
    private init() {}
    
    func addMessage(channelId: String, message: MessageModel, completion: @escaping () -> Void) {
        let collection = firestoreClient.getMessagesPath(channelId: channelId)
        firestoreClient.addDocument(to: collection, document: message.toFirebaseDictionary(), completion: completion)
    }
    
    func addChannel(channel: ChannelModel) {
        firestoreClient.addDocument(to: firestoreClient.getChannelsRootPath(), document: channel.toFirebaseDictionary(), completion: {})
    }
    
    func subscribeOnMessagesChanges(channelId: String, completion: @escaping ([MessageModel]) -> Void) {
        let collection = firestoreClient.getMessagesPath(channelId: channelId)
        messageListener = firestoreClient.addSnapshotListener(for: collection,
                                                              mapper: { document in
                                                                MessageModel(firebaseData: document) },
                                                              completion: completion)
    }
    
    func subscribeOnChannelsChanges(completion: @escaping ([ChannelModel]) -> Void) {
        _ = firestoreClient.addSnapshotListener(for: firestoreClient.getChannelsRootPath(),
                                                mapper: { document in
                                                    ChannelModel(firebaseData: document) },
                                                completion: completion)
    }
    
    func deleteChannel(channelId: String) {
        firestoreClient.deleteDocument(firestoreClient.getChannelPath(channelId: channelId))
    }
    
    func unsubscribeFromMessagesChanges() {
        messageListener?.remove()
    }
}
