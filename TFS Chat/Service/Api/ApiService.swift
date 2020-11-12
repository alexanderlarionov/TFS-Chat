//
//  FirestoreManager.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import FirebaseFirestore

protocol ApiServiceProtocol {
    
    func addMessage(channelId: String, message: MessageDataModel, completion: @escaping () -> Void)
    
    func addChannel(channel: ChannelDataModel)
    
    func subscribeOnMessagesChanges(channelId: String, completion: @escaping ([MessageDataModel]) -> Void)
    
    func subscribeOnChannelsChanges(completion: @escaping ([ChannelDataModel]) -> Void)
    
    func deleteChannel(channelId: String)
    
    func unsubscribeFromMessagesChanges()
}

class ApiService: ApiServiceProtocol {
    
    let apiClient: ApiClientProtocol
    var messageListener: ListenerRegistration?
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func addMessage(channelId: String, message: MessageDataModel, completion: @escaping () -> Void) {
        let collection = apiClient.getMessagesPath(channelId: channelId)
        apiClient.addDocument(to: collection, document: message.toFirebaseDictionary(), completion: completion)
    }
    
    func addChannel(channel: ChannelDataModel) {
        apiClient.addDocument(to: apiClient.getChannelsRootPath(), document: channel.toFirebaseDictionary(), completion: {})
    }
    
    func subscribeOnMessagesChanges(channelId: String, completion: @escaping ([MessageDataModel]) -> Void) {
        let collection = apiClient.getMessagesPath(channelId: channelId)
        messageListener = apiClient.addSnapshotListener(for: collection,
                                                        mapper: { document in
                                                            MessageDataModel(firebaseData: document) },
                                                        completion: completion)
    }
    
    func subscribeOnChannelsChanges(completion: @escaping ([ChannelDataModel]) -> Void) {
        _ = apiClient.addSnapshotListener(for: apiClient.getChannelsRootPath(),
                                          mapper: { document in
                                            ChannelDataModel(firebaseData: document) },
                                          completion: completion)
    }
    
    func deleteChannel(channelId: String) {
        apiClient.deleteDocument(apiClient.getChannelPath(channelId: channelId))
    }
    
    func unsubscribeFromMessagesChanges() {
        messageListener?.remove()
    }
}
