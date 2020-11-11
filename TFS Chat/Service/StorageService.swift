//
//  CoreDataManager.swift
//  TFS Chat
//
//  Created by dmitry on 25.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//
import Foundation

protocol StorageServiceProtocol {
    
    func saveChannels(channelModels: [ChannelModel])
    
    func saveMessages(messageModels: [MessageModel], channelId: String)
    
    func fetchChannel(by id: String) -> ChannelDb?
}

class StorageService: StorageServiceProtocol {
    
    static let instance = StorageService()
    lazy var viewContext = CoreDataStack.instance.viewContext
    
    func saveChannels(channelModels: [ChannelModel]) {
        CoreDataStack.instance.saveChannels(channelModels: channelModels)
    }
    
    func saveMessages(messageModels: [MessageModel], channelId: String) {
        CoreDataStack.instance.saveMessages(messageModels: messageModels, channelId: channelId)
    }
    
    func fetchChannel(by id: String) -> ChannelDb? {
        return CoreDataStack.instance.fetchChannel(by: id, in: viewContext)
    }
}
