//
//  ChannelModel.swift
//  TFS Chat
//
//  Created by dmitry on 17.10.2020.
//  Copyright © 2020 dmitry. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct ChannelDataModel {
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
    
    init(name: String, lastMessage: String?, lastActivity: Date?) {
        self.identifier = ""
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
    }
    
    init?(firebaseData: QueryDocumentSnapshot) {
        let data = firebaseData.data()
        let identifier = firebaseData.documentID
        guard let name = data["name"] as? String else { return nil }
        let lastMessage = data["lastMessage"] as? String
        let createdTimestamp = firebaseData["lastActivity"] as? Timestamp
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = createdTimestamp?.dateValue()
    }
    
    func toFirebaseDictionary() -> [String: Any] {
        var data = [String: Any]()
        data["name"] = self.name
        if self.identifier != "" {
            data["identifier"] = self.identifier
        }
        if let lastMessage = lastMessage {
            data["lastMessage"] = lastMessage
        }
        if let lastActivity = lastActivity {
            data["lastActivity"] = Timestamp(date: lastActivity)
        }
        return data
    }
}
